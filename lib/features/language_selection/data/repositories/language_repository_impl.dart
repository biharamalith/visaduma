// ============================================================
// FILE: lib/features/language_selection/data/repositories/language_repository_impl.dart
// PURPOSE: Implements the abstract LanguageRepository.
//          Bridges domain layer ↔ data layer (local datasource).
//          Converts CacheExceptions → CacheFailure (Either).
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/language_repository.dart';
import '../datasources/language_local_datasource.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDatasource _localDatasource;

  const LanguageRepositoryImpl(this._localDatasource);

  @override
  Future<Either<Failure, String?>> getSavedLanguageCode() async {
    try {
      final code = await _localDatasource.getSavedLanguageCode();
      return Right(code);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveLanguageCode(String languageCode) async {
    try {
      await _localDatasource.saveLanguageCode(languageCode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
