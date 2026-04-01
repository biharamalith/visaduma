// ============================================================
// FILE: lib/features/services/domain/repositories/service_provider_repository.dart
// PURPOSE: Abstract repository for service provider operations.
//          Defines the contract for data operations without implementation details.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_provider_entity.dart';

abstract class ServiceProviderRepository {
  /// Retrieves a list of service providers with optional filters.
  /// 
  /// Parameters:
  /// - [categoryId]: Filter by service category
  /// - [city]: Filter by service area/city
  /// - [minRating]: Minimum rating filter (0.0 - 5.0)
  /// - [isVerified]: Filter for verified providers only
  /// - [sortBy]: Sort order ('rating', 'price', 'distance', 'experience')
  /// - [page]: Page number for pagination (default: 1)
  /// - [limit]: Number of results per page (default: 20)
  Future<Either<Failure, List<ServiceProviderEntity>>> getProviders({
    String? categoryId,
    String? city,
    double? minRating,
    bool? isVerified,
    String? sortBy,
    int page = 1,
    int limit = 20,
  });

  /// Retrieves detailed profile of a specific provider by ID.
  /// Includes portfolio and certifications.
  /// Returns [NotFoundFailure] if the provider doesn't exist.
  Future<Either<Failure, ServiceProviderEntity>> getProviderById(String id);

  /// Searches providers by business name or description.
  /// Uses full-text search for better results.
  Future<Either<Failure, List<ServiceProviderEntity>>> searchProviders({
    required String query,
    String? categoryId,
    int page = 1,
    int limit = 20,
  });

  /// Checks if a provider is available for a specific date and time.
  /// Used for booking conflict detection.
  Future<Either<Failure, bool>> checkAvailability({
    required String providerId,
    required DateTime serviceDate,
    required String serviceTime,
    required double durationHours,
  });
}
