// ============================================================
// FILE: lib/core/network/interceptors/logging_interceptor.dart
// PURPOSE: Dio interceptor for request/response logging.
//          Provides detailed logging for debugging in development.
//          Validates: Requirement 8.5
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that logs HTTP requests and responses for debugging.
/// 
/// This interceptor:
/// - Logs request details (method, URL, headers, body)
/// - Logs response details (status code, headers, body)
/// - Logs error details with stack traces
/// - Only active in debug mode to avoid performance impact in production
/// - Uses color-coded output for better readability
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    this.logRequestHeaders = true,
    this.logRequestBody = true,
    this.logResponseHeaders = false,
    this.logResponseBody = true,
    this.logErrors = true,
  });

  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final bool logErrors;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode && logErrors) {
      _logError(err);
    }
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    debugPrint('');
    debugPrint('╔════════════════════════════════════════════════════════════');
    debugPrint('║ 📤 REQUEST');
    debugPrint('╠════════════════════════════════════════════════════════════');
    debugPrint('║ Method: ${options.method}');
    debugPrint('║ URL: ${options.baseUrl}${options.path}');
    
    if (options.queryParameters.isNotEmpty) {
      debugPrint('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        debugPrint('║   $key: $value');
      });
    }

    if (logRequestHeaders && options.headers.isNotEmpty) {
      debugPrint('║ Headers:');
      options.headers.forEach((key, value) {
        // Mask sensitive headers
        if (key.toLowerCase() == 'authorization') {
          debugPrint('║   $key: Bearer ***');
        } else {
          debugPrint('║   $key: $value');
        }
      });
    }

    if (logRequestBody && options.data != null) {
      debugPrint('║ Body:');
      debugPrint('║   ${_formatData(options.data)}');
    }

    debugPrint('╚════════════════════════════════════════════════════════════');
  }

  void _logResponse(Response<dynamic> response) {
    debugPrint('');
    debugPrint('╔════════════════════════════════════════════════════════════');
    debugPrint('║ 📥 RESPONSE');
    debugPrint('╠════════════════════════════════════════════════════════════');
    debugPrint('║ Status Code: ${response.statusCode}');
    debugPrint('║ URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    
    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      debugPrint('║ Headers:');
      response.headers.map.forEach((key, value) {
        debugPrint('║   $key: ${value.join(', ')}');
      });
    }

    if (logResponseBody && response.data != null) {
      debugPrint('║ Body:');
      debugPrint('║   ${_formatData(response.data)}');
    }

    debugPrint('╚════════════════════════════════════════════════════════════');
  }

  void _logError(DioException err) {
    debugPrint('');
    debugPrint('╔════════════════════════════════════════════════════════════');
    debugPrint('║ ❌ ERROR');
    debugPrint('╠════════════════════════════════════════════════════════════');
    debugPrint('║ Type: ${err.type}');
    debugPrint('║ Message: ${err.message}');
    
    if (err.response != null) {
      debugPrint('║ Status Code: ${err.response?.statusCode}');
      debugPrint('║ URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
      
      if (err.response?.data != null) {
        debugPrint('║ Error Response:');
        debugPrint('║   ${_formatData(err.response?.data)}');
      }
    }

    if (err.stackTrace != null) {
      debugPrint('║ Stack Trace:');
      final stackLines = err.stackTrace.toString().split('\n');
      for (final line in stackLines.take(5)) {
        debugPrint('║   $line');
      }
    }

    debugPrint('╚════════════════════════════════════════════════════════════');
  }

  String _formatData(dynamic data) {
    if (data is Map || data is List) {
      return data.toString();
    }
    return data?.toString() ?? 'null';
  }
}
