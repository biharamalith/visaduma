// ============================================================
// FILE: lib/features/services/domain/repositories/service_category_repository.dart
// PURPOSE: Abstract repository for service category operations.
//          Defines the contract for data operations without implementation details.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_category_entity.dart';

abstract class ServiceCategoryRepository {
  /// Retrieves all active service categories.
  /// Returns a list of categories ordered by display_order.
  Future<Either<Failure, List<ServiceCategoryEntity>>> getCategories();

  /// Retrieves a specific category by its ID.
  /// Returns [NotFoundFailure] if the category doesn't exist.
  Future<Either<Failure, ServiceCategoryEntity>> getCategoryById(String id);

  /// Retrieves categories with provider count information.
  /// Useful for displaying "X providers" on category cards.
  Future<Either<Failure, List<ServiceCategoryEntity>>> getCategoriesWithProviderCount();
}
