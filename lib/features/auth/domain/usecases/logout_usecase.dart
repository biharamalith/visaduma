// ============================================================
// FILE: lib/features/auth/domain/usecases/logout_usecase.dart
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repository;
  const LogoutUsecase(this._repository);

  Future<Either<Failure, void>> call() => _repository.logout();
}
