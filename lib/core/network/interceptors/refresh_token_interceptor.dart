// ============================================================
// FILE: lib/core/network/interceptors/refresh_token_interceptor.dart
// PURPOSE: Dio interceptor for automatic token refresh on 401 errors.
//          Handles token expiration by refreshing and retrying requests.
//          Validates: Requirements 6.1, 6.2, 6.8, 67.3, 67.4
// ============================================================

import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../api_endpoints.dart';

/// Interceptor that handles 401 Unauthorized responses by refreshing tokens.
/// 
/// This interceptor:
/// - Detects 401 responses indicating expired access tokens
/// - Attempts to refresh the access token using the refresh token
/// - Retries the original request with the new access token
/// - Queues concurrent requests during token refresh to avoid race conditions
/// - Clears session and navigates to login if refresh fails
/// - Uses secure storage instead of SharedPreferences for tokens
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this._dio, {SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  final Dio _dio;
  final SecureStorageService _secureStorage;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // If already refreshing, queue this request
    if (_isRefreshing) {
      _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
      return;
    }

    // Start token refresh process
    _isRefreshing = true;
    try {
      final newToken = await _refreshToken();
      
      if (newToken != null) {
        // Retry the original request with new token
        final retried = await _retryRequest(err.requestOptions, newToken);
        handler.resolve(retried);

        // Retry all queued requests with new token
        for (final pending in _pendingRequests) {
          final response = await _retryRequest(pending.options, newToken);
          pending.handler.resolve(response);
        }
        _pendingRequests.clear();
      } else {
        // Refresh failed, clear session
        await _clearSession();
        handler.next(err);
        
        // Reject all queued requests
        for (final pending in _pendingRequests) {
          pending.handler.next(err);
        }
        _pendingRequests.clear();
      }
    } catch (refreshError) {
      // Refresh failed with exception, clear session
      await _clearSession();
      handler.next(err);
      
      // Reject all queued requests
      for (final pending in _pendingRequests) {
        pending.handler.next(err);
      }
      _pendingRequests.clear();
    } finally {
      _isRefreshing = false;
    }
  }

  /// Attempts to refresh the access token using the refresh token.
  /// Returns the new access token on success, null on failure.
  Future<String?> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      // Call refresh token endpoint without Authorization header
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null},
        ),
      );

      // Extract new access token from response
      final newToken = response.data['data']?['access_token'] as String?;
      
      if (newToken != null && newToken.isNotEmpty) {
        // Store new access token in secure storage
        await _secureStorage.saveAccessToken(newToken);
        
        // Update refresh token if provided (token rotation)
        final newRefreshToken = response.data['data']?['refresh_token'] as String?;
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await _secureStorage.saveRefreshToken(newRefreshToken);
        }
        
        return newToken;
      }
      
      return null;
    } catch (e) {
      // Refresh failed
      return null;
    }
  }

  /// Retries a failed request with a new access token.
  Future<Response<dynamic>> _retryRequest(RequestOptions options, String token) {
    return _dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {
          ...options.headers,
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  /// Clears the user session by removing stored tokens from secure storage.
  /// TODO: Navigate to login screen via router
  Future<void> _clearSession() async {
    await _secureStorage.clearAll();
    // TODO(router): Navigate to login screen
    // This should be handled by the auth state management layer
  }
}

/// Internal class to hold pending requests during token refresh.
class _PendingRequest {
  const _PendingRequest(this.options, this.handler);

  final RequestOptions options;
  final ErrorInterceptorHandler handler;
}
