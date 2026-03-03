// ============================================================
// FILE: lib/features/services/data/datasources/services_remote_datasource.dart
// PURPOSE: Dio-based HTTP calls for services endpoints.
// ============================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/service_model.dart';

abstract class ServicesRemoteDatasource {
  Future<List<ServiceModel>> getServices({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  });

  Future<ServiceModel> getServiceById(String id);

  Future<List<String>> getCategories();
}

class ServicesRemoteDatasourceImpl implements ServicesRemoteDatasource {
  final Dio _dio;
  const ServicesRemoteDatasourceImpl(this._dio);

  @override
  Future<List<ServiceModel>> getServices({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
      };
      final res = await _dio.get(ApiEndpoints.services, queryParameters: params);
      final list = res.data['data'] as List<dynamic>;
      return list
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Failed to load services.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    try {
      final res = await _dio.get(ApiEndpoints.serviceById(id));
      return ServiceModel.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Service not found.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final res = await _dio.get(ApiEndpoints.serviceCategories);
      return (res.data['data'] as List<dynamic>).cast<String>();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Failed to load categories.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
