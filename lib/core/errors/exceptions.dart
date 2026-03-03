// ============================================================
// FILE: lib/core/errors/exceptions.dart
// PURPOSE: Data-layer exception types.
//          Exceptions are thrown by datasources and caught by
//          repository implementations, which convert them to
//          Failures before returning via Either.
// ============================================================

/// Base app exception.
abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});

  @override
  String toString() => '$runtimeType: $message';
}

// ── Network exceptions ────────────────────────────────────

/// Thrown by DioClient when there is no internet.
class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.'});
}

/// Thrown by DioClient on non-2xx HTTP responses.
class ServerException extends AppException {
  final int? statusCode;
  final dynamic data;

  const ServerException({
    required super.message,
    this.statusCode,
    this.data,
  });
}

/// Thrown when a request times out.
class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out.'});
}

// ── Auth exceptions ───────────────────────────────────────

/// Thrown on 401 Unauthorised responses.
class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Session expired. Please log in again.'});
}

/// Thrown on 403 Forbidden responses.
class ForbiddenException extends AppException {
  const ForbiddenException({super.message = 'You do not have permission to access this.'});
}

// ── Cache exceptions ──────────────────────────────────────

/// Thrown when SharedPreferences read/write fails.
class CacheException extends AppException {
  const CacheException({super.message = 'Failed to access local storage.'});
}

// ── Parsing exceptions ────────────────────────────────────

/// Thrown when JSON parsing fails.
class ParseException extends AppException {
  const ParseException({super.message = 'Failed to parse server response.'});
}
