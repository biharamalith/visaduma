# Storage Layer

This directory contains secure storage utilities for the VisaDuma application.

## SecureStorageService

A wrapper around `flutter_secure_storage` that provides encrypted storage for sensitive data.

### Features

- **Platform-Specific Security**:
  - iOS: Uses Keychain with AES-256 encryption
  - Android: Uses Android Keystore with encrypted shared preferences
  
- **Token Management**:
  - Secure storage for access tokens
  - Secure storage for refresh tokens
  - Automatic token cleanup on logout

- **User Data Management**:
  - Store user ID and role securely
  - Store arbitrary user data as JSON
  - Complete session management

### Usage

```dart
import 'package:visaduma/core/storage/secure_storage_service.dart';

final secureStorage = SecureStorageService();

// Save tokens
await secureStorage.saveAccessToken('your_access_token');
await secureStorage.saveRefreshToken('your_refresh_token');

// Retrieve tokens
final accessToken = await secureStorage.getAccessToken();
final refreshToken = await secureStorage.getRefreshToken();

// Save user data
await secureStorage.saveUserData({
  'id': 'user_123',
  'email': 'user@example.com',
  'name': 'John Doe',
});

// Retrieve user data
final userData = await secureStorage.getUserData();

// Check if session exists
final hasSession = await secureStorage.hasSession();

// Clear all data (logout)
await secureStorage.clearAll();
```

### Security Compliance

This implementation validates the following requirements:

- **Requirement 67.3**: Use flutter_secure_storage for storing sensitive data on mobile devices
- **Requirement 67.4**: Never store passwords or tokens in SharedPreferences
- **Requirement 67.5**: Implement certificate pinning for API calls (handled by interceptors)

### Configuration

The service is configured with:

- **Android**: `encryptedSharedPreferences: true`
- **iOS**: `accessibility: KeychainAccessibility.first_unlock`

### Integration

The SecureStorageService is integrated with:

1. **AuthInterceptor**: Retrieves access tokens for API requests
2. **RefreshTokenInterceptor**: Manages token refresh and storage
3. **AuthLocalDatasource**: Handles authentication data persistence
4. **SplashScreen**: Checks for existing sessions
5. **ChatViewModel**: Retrieves tokens for WebSocket connections

### Testing

Comprehensive unit tests are available in `test/core/storage/secure_storage_service_test.dart`.

Run tests with:
```bash
flutter test test/core/storage/secure_storage_service_test.dart
```

### Migration from SharedPreferences

All token storage has been migrated from SharedPreferences to SecureStorageService:

- ✅ AuthInterceptor
- ✅ RefreshTokenInterceptor
- ✅ AuthLocalDatasource
- ✅ SplashScreen
- ✅ ChatViewModel

### Error Handling

The service throws `SecureStorageException` when operations fail. Always wrap calls in try-catch blocks:

```dart
try {
  await secureStorage.saveAccessToken(token);
} catch (e) {
  // Handle error
  print('Failed to save token: $e');
}
```
