// ============================================================
// FILE: lib/features/auth/data/datasources/auth_remote_datasource.dart
// PURPOSE: Makes all auth-related HTTP requests via Dio.
//          Returns raw UserModel or throws AppException on error.
//          Called only by AuthRepositoryImpl.
// ============================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  });

  Future<({UserModel user, String accessToken, String refreshToken})> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  Future<void> logout();
  Future<UserModel> getMe();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;

  const AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<({UserModel user, String accessToken, String refreshToken})>
      login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      _assertSuccess(response);
      final data = response.data['data'] as Map<String, dynamic>;
      return (
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<({UserModel user, String accessToken, String refreshToken})>
      register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );
      _assertSuccess(response);
      final data = response.data['data'] as Map<String, dynamic>;
      return (
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      _assertSuccess(response);
      return UserModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _dio.post(ApiEndpoints.resetPassword, data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  void _assertSuccess(Response response) {
    final success = response.data['success'] as bool? ?? false;
    if (!success) {
      throw ServerException(
        message: response.data['message'] as String? ?? 'Server error.',
        statusCode: response.statusCode,
      );
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }
    if (e.response?.statusCode == 401) return const UnauthorizedException();
    if (e.response?.statusCode == 403) return const ForbiddenException();
    return ServerException(
      message: e.response?.data?['message'] as String? ?? e.message ?? 'Unknown error.',
      statusCode: e.response?.statusCode,
    );
  }
}
