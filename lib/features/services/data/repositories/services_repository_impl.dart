// ============================================================
// FILE: lib/features/services/data/repositories/services_repository_impl.dart
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_remote_datasource.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource _remote;
  const ServicesRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _remote.getServices(
        category: category,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> getServiceById(String id) async {
    try {
      final result = await _remote.getServiceById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final result = await _remote.getCategories();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
