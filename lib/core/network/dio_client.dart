// ============================================================
// FILE: lib/core/network/dio_client.dart
// PURPOSE: Singleton Dio HTTP client factory.
//          Builds a pre-configured Dio instance with:
//          - base URL from ApiEndpoints
//          - timeouts
//          - ApiInterceptor (JWT inject + token refresh)
//          - LogInterceptor in debug mode
//
// Usage:
//   final dio = DioClient.instance;
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';
import 'api_interceptor.dart';

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

    // JWT injection + automatic token refresh.
    dio.interceptors.add(ApiInterceptor(dio));

    // Verbose request / response logging (debug builds only).
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
          logPrint: (object) => debugPrint('[Dio] $object'),
        ),
      );
    }

    return dio;
  }
}
