// ============================================================
// FILE: lib/features/services/data/datasources/service_category_remote_datasource.dart
// PURPOSE: Remote data source for service categories API calls
// ============================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/service_category_model.dart';

/// Abstract interface for service category remote data source
abstract class ServiceCategoryRemoteDatasource {
  /// Fetch all service categories
  Future<List<ServiceCategoryModel>> getCategories();

  /// Fetch a single category by ID
  Future<ServiceCategoryModel> getCategoryById(String id);
}

/// Implementation of service category remote data source using Dio
class ServiceCategoryRemoteDatasourceImpl
    implements ServiceCategoryRemoteDatasource {
  final Dio _dio;

  const ServiceCategoryRemoteDatasourceImpl(this._dio);

  @override
  Future<List<ServiceCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.serviceCategories);

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> categoriesJson = data['data'] ?? data;
        
        return categoriesJson
            .map((json) => ServiceCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch categories',
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
  Future<ServiceCategoryModel> getCategoryById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.serviceCategories}/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        final categoryJson = data['data'] ?? data;
        
        return ServiceCategoryModel.fromJson(categoryJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Category not found');
      } else {
        throw ServerException(
          message: 'Failed to fetch category',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Category not found');
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
