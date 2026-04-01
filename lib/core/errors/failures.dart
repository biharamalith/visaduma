// ============================================================
// FILE: lib/core/errors/failures.dart
// PURPOSE: Domain-layer failure types (Left side of Either).
//          All repository interfaces return Either<Failure, T>.
//          Add new failure sub-types here as the app grows.
// ============================================================

import 'package:equatable/equatable.dart';

/// Base failure class — all failures extend this.
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

// ── Network failures ──────────────────────────────────────

/// Thrown when the device has no internet access.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

/// Thrown when the server returns a non-2xx HTTP response.
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    super.message = 'Server error. Please try again.',
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Thrown when the request times out.
class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timed out.'});
}

// ── Auth failures ─────────────────────────────────────────

/// Thrown when the user is not authenticated or token is expired.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Unauthorised. Please log in again.'});
}

/// Thrown when authentication credentials are invalid.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message = 'Authentication failed. Please login again.'});
}

/// Thrown when the user does not have permission to access a resource.
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message = 'Access denied.'});
}

/// Thrown when the user does not have permission to perform an action.
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({super.message = 'You do not have permission to perform this action.'});
}

// ── Validation failures ───────────────────────────────────

/// Thrown when request/input data fails validation.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

// ── Local storage failures ────────────────────────────────

/// Thrown when reading/writing SharedPreferences fails.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local cache error.'});
}

// ── General failures ──────────────────────────────────────

/// Catch-all for unexpected errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred.'});
}

/// Thrown when a requested resource is not found (404).
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found.'});
}
