// ============================================================
// FILE: lib/features/services/domain/repositories/services_repository.dart
// PURPOSE: Abstract repository for service discovery & detail.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';

abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, ServiceEntity>> getServiceById(String id);

  Future<Either<Failure, List<String>>> getCategories();
}
