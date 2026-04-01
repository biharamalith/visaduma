// ============================================================
// FILE: lib/features/auth/data/datasources/auth_local_datasource.dart
// PURPOSE: Manages local storage of auth tokens and user data
//          via SecureStorageService.
//          Validates: Requirements 67.3, 67.4
// ============================================================

import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDatasource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<String?> getAccessToken();
  Future<void> clearSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  AuthLocalDatasourceImpl({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  final SecureStorageService _secureStorage;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _secureStorage.saveAccessToken(accessToken);
      await _secureStorage.saveRefreshToken(refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to save auth tokens: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.getAccessToken();
    } catch (e) {
      throw CacheException(message: 'Failed to read auth token: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _secureStorage.clearAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear session: $e');
    }
  }
}
