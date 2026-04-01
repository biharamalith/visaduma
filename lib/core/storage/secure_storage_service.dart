// ============================================================
// FILE: lib/core/storage/secure_storage_service.dart
// PURPOSE: Secure storage wrapper for sensitive data using flutter_secure_storage.
//          Provides encrypted storage for tokens and user data on iOS Keychain
//          and Android Keystore.
//          Validates: Requirements 67.3, 67.4, 67.5
// ============================================================

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_strings.dart';

/// Service for securely storing sensitive data using platform-specific secure storage.
/// 
/// This service:
/// - Uses iOS Keychain for iOS devices
/// - Uses Android Keystore for Android devices
/// - Encrypts all data at rest
/// - Provides methods for storing/retrieving tokens and user data
/// - Never stores sensitive data in SharedPreferences
/// 
/// **Security Features:**
/// - AES-256 encryption on Android
/// - Keychain encryption on iOS
/// - Automatic key generation and management
/// - Secure deletion of data
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  // ── Token Management ──────────────────────────────────────

  /// Stores the access token securely.
  /// 
  /// **Validates:** Requirement 67.3 - Use flutter_secure_storage for sensitive data
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(
        key: AppStrings.keyAuthToken,
        value: token,
      );
    } catch (e) {
      throw SecureStorageException('Failed to save access token: $e');
    }
  }

  /// Retrieves the access token from secure storage.
  /// 
  /// Returns null if no token is stored.
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: AppStrings.keyAuthToken);
    } catch (e) {
      throw SecureStorageException('Failed to read access token: $e');
    }
  }

  /// Stores the refresh token securely.
  /// 
  /// **Validates:** Requirement 67.3 - Use flutter_secure_storage for sensitive data
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(
        key: AppStrings.keyRefreshToken,
        value: token,
      );
    } catch (e) {
      throw SecureStorageException('Failed to save refresh token: $e');
    }
  }

  /// Retrieves the refresh token from secure storage.
  /// 
  /// Returns null if no token is stored.
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppStrings.keyRefreshToken);
    } catch (e) {
      throw SecureStorageException('Failed to read refresh token: $e');
    }
  }

  /// Deletes both access and refresh tokens from secure storage.
  /// 
  /// Used during logout to clear the user session.
  Future<void> deleteTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: AppStrings.keyAuthToken),
        _storage.delete(key: AppStrings.keyRefreshToken),
      ]);
    } catch (e) {
      throw SecureStorageException('Failed to delete tokens: $e');
    }
  }

  // ── User Data Management ──────────────────────────────────

  /// Stores user ID securely.
  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(
        key: AppStrings.keyUserId,
        value: userId,
      );
    } catch (e) {
      throw SecureStorageException('Failed to save user ID: $e');
    }
  }

  /// Retrieves the user ID from secure storage.
  /// 
  /// Returns null if no user ID is stored.
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: AppStrings.keyUserId);
    } catch (e) {
      throw SecureStorageException('Failed to read user ID: $e');
    }
  }

  /// Stores user role securely.
  Future<void> saveUserRole(String role) async {
    try {
      await _storage.write(
        key: AppStrings.keyUserRole,
        value: role,
      );
    } catch (e) {
      throw SecureStorageException('Failed to save user role: $e');
    }
  }

  /// Retrieves the user role from secure storage.
  /// 
  /// Returns null if no role is stored.
  Future<String?> getUserRole() async {
    try {
      return await _storage.read(key: AppStrings.keyUserRole);
    } catch (e) {
      throw SecureStorageException('Failed to read user role: $e');
    }
  }

  /// Stores user data as JSON.
  /// 
  /// **Validates:** Requirement 67.3 - Use flutter_secure_storage for sensitive data
  /// 
  /// The [data] map is serialized to JSON and stored securely.
  /// Use this for storing sensitive user information like email, phone, etc.
  Future<void> saveUserData(Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      await _storage.write(
        key: _userDataKey,
        value: jsonString,
      );
    } catch (e) {
      throw SecureStorageException('Failed to save user data: $e');
    }
  }

  /// Retrieves user data from secure storage.
  /// 
  /// Returns null if no user data is stored.
  /// Throws [SecureStorageException] if JSON parsing fails.
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final jsonString = await _storage.read(key: _userDataKey);
      if (jsonString == null) return null;
      
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw SecureStorageException('Failed to read user data: $e');
    }
  }

  /// Deletes user data from secure storage.
  Future<void> deleteUserData() async {
    try {
      await Future.wait([
        _storage.delete(key: AppStrings.keyUserId),
        _storage.delete(key: AppStrings.keyUserRole),
        _storage.delete(key: _userDataKey),
      ]);
    } catch (e) {
      throw SecureStorageException('Failed to delete user data: $e');
    }
  }

  // ── Complete Session Management ───────────────────────────

  /// Clears all stored data from secure storage.
  /// 
  /// **Validates:** Requirement 67.4 - Never store passwords/tokens in SharedPreferences
  /// 
  /// This method:
  /// - Deletes all tokens (access and refresh)
  /// - Deletes all user data
  /// - Should be called during logout
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw SecureStorageException('Failed to clear all data: $e');
    }
  }

  /// Checks if user session exists (has valid tokens).
  /// 
  /// Returns true if both access and refresh tokens are present.
  Future<bool> hasSession() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();
      return accessToken != null && refreshToken != null;
    } catch (e) {
      return false;
    }
  }

  // ── Private Constants ─────────────────────────────────────

  static const String _userDataKey = 'user_data';
}

/// Exception thrown when secure storage operations fail.
class SecureStorageException implements Exception {
  const SecureStorageException(this.message);

  final String message;

  @override
  String toString() => 'SecureStorageException: $message';
}
