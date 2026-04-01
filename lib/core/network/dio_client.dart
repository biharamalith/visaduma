// ============================================================
// FILE: lib/core/network/dio_client.dart
// PURPOSE: Singleton Dio HTTP client factory.
//          Builds a pre-configured Dio instance with:
//          - base URL from ApiEndpoints
//          - timeouts
//          - AuthInterceptor (JWT injection)
//          - RefreshTokenInterceptor (automatic token refresh)
//          - ErrorInterceptor (error handling and conversion)
//          - LoggingInterceptor (debug logging)
//
// Usage:
//   final dio = DioClient.instance;
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio? _dio;

  /// Returns the shared [Dio] instance, creating it on first call.
  static Dio get instance {
    _dio ??= _buildDio();
    return _dio!;
  }

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiEndpoints.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeoutMs),
        sendTimeout: const Duration(milliseconds: ApiEndpoints.sendTimeoutMs),
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Add interceptors in order of execution:
    
    // 1. Auth interceptor - injects JWT token into requests
    dio.interceptors.add(AuthInterceptor());

    // 2. Refresh token interceptor - handles 401 errors and token refresh
    dio.interceptors.add(RefreshTokenInterceptor(dio));

    // 3. Error interceptor - converts errors to domain failures
    dio.interceptors.add(ErrorInterceptor());

    // 4. Logging interceptor - logs requests/responses (debug only)
    if (kDebugMode) {
      dio.interceptors.add(
        LoggingInterceptor(),
      );
    }

    return dio;
  }

  /// Resets the Dio instance (useful for testing or re-configuration)
  static void reset() {
    _dio = null;
  }
}

