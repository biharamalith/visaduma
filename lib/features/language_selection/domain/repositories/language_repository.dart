// ============================================================
// FILE: lib/features/language_selection/domain/repositories/language_repository.dart
// PURPOSE: Abstract repository interface for language preferences.
//          Defined in the domain layer — no Flutter or package
//          dependencies allowed here (except dartz for Either).
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class LanguageRepository {
  /// Returns the previously saved BCP-47 language code.
  /// Returns Right(null) if no language has been saved yet.
  Future<Either<Failure, String?>> getSavedLanguageCode();

  /// Persists the selected [languageCode] for future sessions.
  Future<Either<Failure, void>> saveLanguageCode(String languageCode);
}
