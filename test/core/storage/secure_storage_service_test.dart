// ============================================================
// FILE: test/core/storage/secure_storage_service_test.dart
// PURPOSE: Unit tests for SecureStorageService
//          Validates: Requirements 67.3, 67.4, 67.5
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:visaduma/core/storage/secure_storage_service.dart';
import 'package:visaduma/core/constants/app_strings.dart';

// Mock implementation of FlutterSecureStorage for testing
class MockSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return Map.from(_storage);
  }

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  AndroidOptions get aOptions => throw UnimplementedError();

  @override
  IOSOptions get iOptions => throw UnimplementedError();

  @override
  LinuxOptions get lOptions => throw UnimplementedError();

  @override
  MacOsOptions get mOptions => throw UnimplementedError();

  @override
  WebOptions get webOptions => throw UnimplementedError();

  @override
  WindowsOptions get wOptions => throw UnimplementedError();

  @override
  Future<bool?> isCupertinoProtectedDataAvailable() async => true;

  @override
  Stream<bool>? get onCupertinoProtectedDataAvailabilityChanged => null;

  @override
  void registerListener({
    required String key,
    required void Function(String?) listener,
  }) {}

  @override
  void unregisterListener({
    required String key,
    required void Function(String?) listener,
  }) {}

  @override
  void unregisterAllListenersForKey({required String key}) {}

  @override
  void unregisterAllListeners() {}
}

void main() {
  late SecureStorageService service;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();
    service = SecureStorageService(storage: mockStorage);
  });

  group('Token Management', () {
    test('saveAccessToken stores token securely', () async {
      // Arrange
      const token = 'test_access_token_123';

      // Act
      await service.saveAccessToken(token);

      // Assert
      final stored = await mockStorage.read(key: AppStrings.keyAuthToken);
      expect(stored, equals(token));
    });

    test('getAccessToken retrieves stored token', () async {
      // Arrange
      const token = 'test_access_token_123';
      await mockStorage.write(key: AppStrings.keyAuthToken, value: token);

      // Act
      final result = await service.getAccessToken();

      // Assert
      expect(result, equals(token));
    });

    test('getAccessToken returns null when no token stored', () async {
      // Act
      final result = await service.getAccessToken();

      // Assert
      expect(result, isNull);
    });

    test('saveRefreshToken stores token securely', () async {
      // Arrange
      const token = 'test_refresh_token_456';

      // Act
      await service.saveRefreshToken(token);

      // Assert
      final stored = await mockStorage.read(key: AppStrings.keyRefreshToken);
      expect(stored, equals(token));
    });

    test('getRefreshToken retrieves stored token', () async {
      // Arrange
      const token = 'test_refresh_token_456';
      await mockStorage.write(key: AppStrings.keyRefreshToken, value: token);

      // Act
      final result = await service.getRefreshToken();

      // Assert
      expect(result, equals(token));
    });

    test('deleteTokens removes both access and refresh tokens', () async {
      // Arrange
      await mockStorage.write(
        key: AppStrings.keyAuthToken,
        value: 'access_token',
      );
      await mockStorage.write(
        key: AppStrings.keyRefreshToken,
        value: 'refresh_token',
      );

      // Act
      await service.deleteTokens();

      // Assert
      final accessToken = await mockStorage.read(key: AppStrings.keyAuthToken);
      final refreshToken =
          await mockStorage.read(key: AppStrings.keyRefreshToken);
      expect(accessToken, isNull);
      expect(refreshToken, isNull);
    });
  });

  group('User Data Management', () {
    test('saveUserId stores user ID securely', () async {
      // Arrange
      const userId = 'user_123';

      // Act
      await service.saveUserId(userId);

      // Assert
      final stored = await mockStorage.read(key: AppStrings.keyUserId);
      expect(stored, equals(userId));
    });

    test('getUserId retrieves stored user ID', () async {
      // Arrange
      const userId = 'user_123';
      await mockStorage.write(key: AppStrings.keyUserId, value: userId);

      // Act
      final result = await service.getUserId();

      // Assert
      expect(result, equals(userId));
    });

    test('saveUserRole stores role securely', () async {
      // Arrange
      const role = 'provider';

      // Act
      await service.saveUserRole(role);

      // Assert
      final stored = await mockStorage.read(key: AppStrings.keyUserRole);
      expect(stored, equals(role));
    });

    test('getUserRole retrieves stored role', () async {
      // Arrange
      const role = 'provider';
      await mockStorage.write(key: AppStrings.keyUserRole, value: role);

      // Act
      final result = await service.getUserRole();

      // Assert
      expect(result, equals(role));
    });

    test('saveUserData stores JSON data securely', () async {
      // Arrange
      final userData = {
        'id': 'user_123',
        'email': 'test@example.com',
        'name': 'Test User',
      };

      // Act
      await service.saveUserData(userData);

      // Assert
      final result = await service.getUserData();
      expect(result, isNotNull);
      expect(result!['id'], equals('user_123'));
      expect(result['email'], equals('test@example.com'));
      expect(result['name'], equals('Test User'));
    });

    test('getUserData returns null when no data stored', () async {
      // Act
      final result = await service.getUserData();

      // Assert
      expect(result, isNull);
    });

    test('deleteUserData removes all user data', () async {
      // Arrange
      await mockStorage.write(key: AppStrings.keyUserId, value: 'user_123');
      await mockStorage.write(key: AppStrings.keyUserRole, value: 'provider');
      await service.saveUserData({'email': 'test@example.com'});

      // Act
      await service.deleteUserData();

      // Assert
      final userId = await mockStorage.read(key: AppStrings.keyUserId);
      final userRole = await mockStorage.read(key: AppStrings.keyUserRole);
      final userData = await service.getUserData();
      expect(userId, isNull);
      expect(userRole, isNull);
      expect(userData, isNull);
    });
  });

  group('Session Management', () {
    test('clearAll removes all stored data', () async {
      // Arrange
      await service.saveAccessToken('access_token');
      await service.saveRefreshToken('refresh_token');
      await service.saveUserId('user_123');
      await service.saveUserRole('provider');
      await service.saveUserData({'email': 'test@example.com'});

      // Act
      await service.clearAll();

      // Assert
      final allData = await mockStorage.readAll();
      expect(allData, isEmpty);
    });

    test('hasSession returns true when tokens exist', () async {
      // Arrange
      await service.saveAccessToken('access_token');
      await service.saveRefreshToken('refresh_token');

      // Act
      final result = await service.hasSession();

      // Assert
      expect(result, isTrue);
    });

    test('hasSession returns false when no tokens exist', () async {
      // Act
      final result = await service.hasSession();

      // Assert
      expect(result, isFalse);
    });

    test('hasSession returns false when only access token exists', () async {
      // Arrange
      await service.saveAccessToken('access_token');

      // Act
      final result = await service.hasSession();

      // Assert
      expect(result, isFalse);
    });

    test('hasSession returns false when only refresh token exists', () async {
      // Arrange
      await service.saveRefreshToken('refresh_token');

      // Act
      final result = await service.hasSession();

      // Assert
      expect(result, isFalse);
    });
  });

  group('Error Handling', () {
    test('getUserData handles invalid JSON gracefully', () async {
      // Arrange
      await mockStorage.write(key: 'user_data', value: 'invalid_json{');

      // Act & Assert
      expect(
        () => service.getUserData(),
        throwsA(isA<SecureStorageException>()),
      );
    });
  });
}
