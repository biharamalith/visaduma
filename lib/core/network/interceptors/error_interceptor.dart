// ============================================================
// FILE: lib/core/network/interceptors/error_interceptor.dart
// PURPOSE: Dio interceptor for error handling and conversion.
//          Converts HTTP errors to domain failures for clean architecture.
//          Validates: Requirements 6.5, 6.8
// ============================================================

import 'package:dio/dio.dart';
import '../../errors/failures.dart';

/// Interceptor that handles errors and converts them to domain failures.
/// 
/// This interceptor:
/// - Catches all Dio exceptions
/// - Converts HTTP errors to appropriate Failure types
/// - Provides user-friendly error messages
/// - Handles network connectivity issues
/// - Handles timeout errors
/// - Handles server errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to Failure
    final failure = _handleError(err);
    
    // Create a new DioException with the failure message
    final enhancedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: failure,
      message: failure.message,
    );

    handler.next(enhancedError);
  }

  /// Converts DioException to appropriate Failure type.
  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'Connection timeout. Please check your internet connection and try again.',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          message: 'Security certificate error. Please try again later.',
        );

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NetworkFailure(
            message: 'No internet connection. Please check your network settings.',
          );
        }
        return NetworkFailure(
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }

  /// Handles HTTP response errors based on status code.
  Failure _handleResponseError(Response<dynamic>? response) {
    if (response == null) {
      return ServerFailure(
        message: 'No response from server. Please try again later.',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Extract error message from response if available
    String? errorMessage;
    if (data is Map<String, dynamic>) {
      errorMessage = data['message'] as String? ?? 
                     data['error'] as String? ??
                     data['msg'] as String?;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: errorMessage ?? 'Invalid request. Please check your input.',
        );

      case 401:
        return AuthenticationFailure(
          message: errorMessage ?? 'Authentication failed. Please login again.',
        );

      case 403:
        return AuthorizationFailure(
          message: errorMessage ?? 'You do not have permission to perform this action.',
        );

      case 404:
        return NotFoundFailure(
          message: errorMessage ?? 'The requested resource was not found.',
        );

      case 409:
        return ValidationFailure(
          message: errorMessage ?? 'Conflict. The resource already exists.',
        );

      case 422:
        return ValidationFailure(
          message: errorMessage ?? 'Validation failed. Please check your input.',
        );

      case 429:
        return NetworkFailure(
          message: errorMessage ?? 'Too many requests. Please try again later.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: errorMessage ?? 'Server error. Please try again later.',
        );

      default:
        return ServerFailure(
          message: errorMessage ?? 'An error occurred. Please try again.',
        );
    }
  }
}
