// ============================================================
// FILE: lib/features/language_selection/domain/usecases/get_saved_language_usecase.dart
// PURPOSE: Single-responsibility use case:
//          Retrieve the language code saved from a previous session.
//          Returns Either<Failure, String?>.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/language_repository.dart';

class GetSavedLanguageUsecase {
  final LanguageRepository _repository;

  const GetSavedLanguageUsecase(this._repository);

  Future<Either<Failure, String?>> call() {
    return _repository.getSavedLanguageCode();
  }
}
