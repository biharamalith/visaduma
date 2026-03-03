// ============================================================
// FILE: lib/features/auth/domain/repositories/auth_repository.dart
// PURPOSE: Abstract interface for all auth operations.
//          Implemented by AuthRepositoryImpl in the data layer.
//          Use dartz Either<Failure, T> for error handling.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Authenticates the user with [email] and [password].
  /// Returns the authenticated [UserEntity] on success.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  Future<Either<Failure, UserEntity>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  /// Logs the current user out (clears tokens locally + revokes on server).
  Future<Either<Failure, void>> logout();

  /// Returns the currently authenticated user, or null if not logged in.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Sends a password reset OTP to [email].
  Future<Either<Failure, void>> forgotPassword(String email);

  /// Resets the password using the OTP received via email.
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Returns true if a valid access token exists locally.
  Future<bool> isAuthenticated();
}
