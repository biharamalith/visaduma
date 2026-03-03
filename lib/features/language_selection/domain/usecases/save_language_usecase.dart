// ============================================================
// FILE: lib/features/language_selection/domain/usecases/save_language_usecase.dart
// PURPOSE: Single-responsibility use case:
//          Persist the user's chosen language code.
//          Returns Either<Failure, void>.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/language_repository.dart';

class SaveLanguageUsecase {
  final LanguageRepository _repository;

  const SaveLanguageUsecase(this._repository);

  Future<Either<Failure, void>> call(String languageCode) {
    return _repository.saveLanguageCode(languageCode);
  }
}
