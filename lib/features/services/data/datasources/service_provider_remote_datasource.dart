// ============================================================
// FILE: lib/features/services/data/datasources/service_provider_remote_datasource.dart
// PURPOSE: Remote data source for service providers API calls
// ============================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/service_provider_model.dart';
import '../models/portfolio_model.dart';

/// Query parameters for filtering service providers
class ProviderQueryParams {
  final String? categoryId;
  final String? city;
  final double? minRating;
  final String? sortBy; // 'rating', 'price', 'distance'
  final int? page;
  final int? limit;

  const ProviderQueryParams({
    this.categoryId,
    this.city,
    this.minRating,
    this.sortBy,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (categoryId != null) map['category_id'] = categoryId;
    if (city != null) map['city'] = city;
    if (minRating != null) map['min_rating'] = minRating;
    if (sortBy != null) map['sort_by'] = sortBy;
    if (page != null) map['page'] = page;
    if (limit != null) map['limit'] = limit;
    return map;
  }
}

/// Abstract interface for service provider remote data source
abstract class ServiceProviderRemoteDatasource {
  /// Fetch service providers with optional filters
  Future<List<ServiceProviderModel>> getProviders([ProviderQueryParams? params]);

  /// Fetch a single provider by ID
  Future<ServiceProviderModel> getProviderById(String id);

  /// Fetch portfolio images for a provider
  Future<List<PortfolioModel>> getProviderPortfolio(String providerId);

  /// Check provider availability for a specific date and time
  Future<bool> checkProviderAvailability({
    required String providerId,
    required String date,
    required String time,
    required double durationHours,
  });
}

/// Implementation of service provider remote data source using Dio
class ServiceProviderRemoteDatasourceImpl
    implements ServiceProviderRemoteDatasource {
  final Dio _dio;

  const ServiceProviderRemoteDatasourceImpl(this._dio);

  @override
  Future<List<ServiceProviderModel>> getProviders([ProviderQueryParams? params]) async {
    try {
      final queryParams = params?.toJson() ?? {};
      final response = await _dio.get(
        ApiEndpoints.serviceProviders,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> providersJson = data['data'] ?? data;
        
        return providersJson
            .map((json) => ServiceProviderModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch providers',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<ServiceProviderModel> getProviderById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.providerById(id));

      if (response.statusCode == 200) {
        final data = response.data;
        final providerJson = data['data'] ?? data;
        
        return ServiceProviderModel.fromJson(providerJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Provider not found');
      } else {
        throw ServerException(
          message: 'Failed to fetch provider',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Provider not found');
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<PortfolioModel>> getProviderPortfolio(String providerId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.providerById(providerId)}/portfolio',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> portfolioJson = data['data'] ?? data;
        
        return portfolioJson
            .map((json) => PortfolioModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Provider not found');
      } else {
        throw ServerException(
          message: 'Failed to fetch portfolio',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Provider not found');
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<bool> checkProviderAvailability({
    required String providerId,
    required String date,
    required String time,
    required double durationHours,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.providerById(providerId)}/availability',
        queryParameters: {
          'date': date,
          'time': time,
          'duration_hours': durationHours,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['available'] as bool? ?? false;
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Provider not found');
      } else {
        throw ServerException(
          message: 'Failed to check availability',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Provider not found');
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
