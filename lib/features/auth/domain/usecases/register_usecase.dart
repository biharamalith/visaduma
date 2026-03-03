// ============================================================
// FILE: lib/features/auth/domain/usecases/register_usecase.dart
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;
  const RegisterUsecase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) =>
      _repository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
}
