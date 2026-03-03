// ============================================================
// FILE: lib/core/network/api_interceptor.dart
// PURPOSE: Dio interceptor that:
//   1. Injects JWT Bearer token into every request header.
//   2. Handles 401 responses by attempting a token refresh.
//   3. Queues concurrent requests during refresh (lock/unlock).
//   4. Logs requests and responses in debug mode.
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_strings.dart';
import 'api_endpoints.dart';

class ApiInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  ApiInterceptor(this._dio);

  // ── On Request ────────────────────────────────────────────
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppStrings.keyAuthToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      debugPrint('→ [${options.method}] ${options.path}');
    }

    handler.next(options);
  }

  // ── On Response ───────────────────────────────────────────
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('← [${response.statusCode}] ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  // ── On Error ──────────────────────────────────────────────
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If we're already refreshing, queue this request.
      if (_isRefreshing) {
        _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry the original request with the new token.
          final retried = await _retryRequest(err.requestOptions, newToken);
          handler.resolve(retried);

          // Retry all queued requests.
          for (final pending in _pendingRequests) {
            final r = await _retryRequest(pending.options, newToken);
            pending.handler.resolve(r);
          }
          _pendingRequests.clear();
        } else {
          await _clearSession();
          handler.next(err);
        }
      } catch (_) {
        await _clearSession();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      if (kDebugMode) {
        debugPrint('✗ [${err.response?.statusCode}] ${err.requestOptions.path}: ${err.message}');
      }
      handler.next(err);
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  Future<String?> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(AppStrings.keyRefreshToken);
    if (refreshToken == null) return null;

    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final newToken = response.data['data']?['access_token'] as String?;
      if (newToken != null) {
        await prefs.setString(AppStrings.keyAuthToken, newToken);
      }
      return newToken;
    } catch (_) {
      return null;
    }
  }

  Future<Response> _retryRequest(RequestOptions options, String token) {
    return _dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {...options.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.keyAuthToken);
    await prefs.remove(AppStrings.keyRefreshToken);
    // TODO(router): navigate to login screen via router ref.
  }
}

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  const _PendingRequest(this.options, this.handler);
}
