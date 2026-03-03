// ============================================================
// FILE: lib/features/auth/data/datasources/auth_local_datasource.dart
// PURPOSE: Manages local storage of auth tokens and user data
//          via SharedPreferences.
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_strings.dart';
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
  const AuthLocalDatasourceImpl();

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppStrings.keyAuthToken, accessToken);
      await prefs.setString(AppStrings.keyRefreshToken, refreshToken);
    } catch (_) {
      throw const CacheException(message: 'Failed to save auth tokens.');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppStrings.keyAuthToken);
    } catch (_) {
      throw const CacheException(message: 'Failed to read auth token.');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppStrings.keyAuthToken);
      await prefs.remove(AppStrings.keyRefreshToken);
      await prefs.remove(AppStrings.keyUserId);
      await prefs.remove(AppStrings.keyUserRole);
    } catch (_) {
      throw const CacheException(message: 'Failed to clear session.');
    }
  }
}
