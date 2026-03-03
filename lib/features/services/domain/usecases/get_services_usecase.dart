// ============================================================
// FILE: lib/features/services/domain/usecases/get_services_usecase.dart
// PURPOSE: Fetches a paginated, optionally filtered list of services.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/services_repository.dart';

class GetServicesUsecase {
  final ServicesRepository _repository;
  const GetServicesUsecase(this._repository);

  Future<Either<Failure, List<ServiceEntity>>> call({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  }) =>
      _repository.getServices(
        category: category,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
      );
}
