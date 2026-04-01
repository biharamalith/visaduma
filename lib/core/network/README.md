# Network Module

This module provides HTTP client configuration with Dio, including authentication, token refresh, error handling, and logging interceptors.

## Overview

The network module implements a clean, maintainable HTTP client setup following clean architecture principles. It provides:

- **JWT Authentication**: Automatic token injection into requests
- **Token Refresh**: Automatic token refresh on 401 errors
- **Error Handling**: Conversion of HTTP errors to domain failures
- **Logging**: Detailed request/response logging in debug mode
- **Environment Configuration**: Configurable base URL for different environments

## Architecture

```
lib/core/network/
├── dio_client.dart              # Singleton Dio instance factory
├── api_endpoints.dart           # Centralized API endpoint definitions
├── network.dart                 # Barrel export file
└── interceptors/
    ├── auth_interceptor.dart           # JWT token injection
    ├── refresh_token_interceptor.dart  # Automatic token refresh
    ├── error_interceptor.dart          # Error handling & conversion
    └── logging_interceptor.dart        # Request/response logging
```

## Usage

### Basic Usage

```dart
import 'package:visaduma/core/network/dio_client.dart';
import 'package:visaduma/core/network/api_endpoints.dart';

// Get the configured Dio instance
final dio = DioClient.instance;

// Make API calls
final response = await dio.get(ApiEndpoints.profile);
```

### In Repository Implementations

```dart
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final user = UserModel.fromJson(response.data['data']['user']);
      return Right(user);
    } on DioException catch (e) {
      // Error interceptor has already converted this to a Failure
      final failure = e.error as Failure;
      return Left(failure);
    }
  }
}
```

## Interceptors

### 1. AuthInterceptor

Automatically injects JWT Bearer token into all requests.

**Features:**
- Retrieves access token from SharedPreferences
- Adds `Authorization: Bearer <token>` header
- Sets `Accept` and `Content-Type` headers for JSON

**Requirements:** 6.6, 6.7

### 2. RefreshTokenInterceptor

Handles 401 Unauthorized responses by refreshing tokens.

**Features:**
- Detects expired access tokens (401 responses)
- Automatically refreshes using refresh token
- Retries original request with new token
- Queues concurrent requests during refresh
- Clears session if refresh fails

**Requirements:** 6.1, 6.2, 6.8

### 3. ErrorInterceptor

Converts HTTP errors to domain failures.

**Features:**
- Handles network connectivity errors
- Handles timeout errors
- Converts HTTP status codes to appropriate Failure types
- Extracts error messages from API responses
- Provides user-friendly error messages

**Requirements:** 6.5, 6.8

**Error Mapping:**
- 400 → ValidationFailure
- 401 → AuthenticationFailure
- 403 → AuthorizationFailure
- 404 → NotFoundFailure
- 409 → ValidationFailure (conflict)
- 422 → ValidationFailure
- 429 → NetworkFailure (rate limit)
- 500-504 → ServerFailure
- Timeout → NetworkFailure
- No connection → NetworkFailure

### 4. LoggingInterceptor

Logs HTTP requests and responses for debugging.

**Features:**
- Logs request method, URL, headers, body
- Logs response status, headers, body
- Logs errors with stack traces
- Color-coded output for readability
- Masks sensitive headers (Authorization)
- Only active in debug mode

**Requirements:** 8.5

## Configuration

### Base URL

The base URL is configured in `api_endpoints.dart` and can be set via environment variables:

```dart
// Default (development)
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000/api/v1',
);
```

To use a different base URL:

```bash
# Development
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3000/api/v1

# Staging
flutter run --dart-define=API_BASE_URL=https://staging-api.visaduma.lk/v1

# Production
flutter run --dart-define=API_BASE_URL=https://api.visaduma.lk/v1
```

### Timeouts

Timeouts are configured in `api_endpoints.dart`:

```dart
static const int connectTimeoutMs = 15000;  // 15 seconds
static const int receiveTimeoutMs = 20000;  // 20 seconds
static const int sendTimeoutMs = 20000;     // 20 seconds
```

## Token Management

### Token Storage

Tokens are stored in SharedPreferences:

```dart
// Access token
await prefs.setString(AppStrings.keyAuthToken, accessToken);

// Refresh token
await prefs.setString(AppStrings.keyRefreshToken, refreshToken);
```

### Token Refresh Flow

1. Request fails with 401 Unauthorized
2. RefreshTokenInterceptor intercepts the error
3. Retrieves refresh token from SharedPreferences
4. Calls `/auth/refresh` endpoint
5. Stores new access token
6. Retries original request with new token
7. If refresh fails, clears session

### Token Rotation

The backend implements refresh token rotation (Requirement 6.2). When a refresh token is used:

1. A new access token is issued
2. A new refresh token is issued
3. The old refresh token is invalidated

The RefreshTokenInterceptor handles this automatically by updating both tokens.

## Error Handling

All HTTP errors are converted to domain `Failure` types by the ErrorInterceptor:

```dart
try {
  final response = await dio.get('/endpoint');
  // Handle success
} on DioException catch (e) {
  final failure = e.error as Failure;
  
  if (failure is NetworkFailure) {
    // Handle network error
  } else if (failure is AuthenticationFailure) {
    // Handle auth error
  } else if (failure is ValidationFailure) {
    // Handle validation error
  }
}
```

## Testing

### Unit Tests

```dart
test('should create a singleton Dio instance', () {
  final dio1 = DioClient.instance;
  final dio2 = DioClient.instance;
  expect(dio1, same(dio2));
});
```

### Mocking in Tests

```dart
// Create a mock Dio instance for testing
final mockDio = MockDio();

// Inject into repository
final repository = AuthRepositoryImpl(dio: mockDio);

// Stub responses
when(mockDio.post(any, data: anyNamed('data')))
  .thenAnswer((_) async => Response(
    data: {'data': {'user': {...}}},
    statusCode: 200,
    requestOptions: RequestOptions(path: '/auth/login'),
  ));
```

## Security Considerations

1. **HTTPS Only**: All production requests must use HTTPS
2. **Token Storage**: Tokens stored in SharedPreferences (consider flutter_secure_storage for production)
3. **Token Masking**: Authorization headers are masked in logs
4. **Token Expiry**: Access tokens expire in 15 minutes (backend configuration)
5. **Refresh Token Rotation**: Refresh tokens are rotated on each use
6. **Session Clearing**: Tokens are cleared on logout or refresh failure

## Future Enhancements

1. **Secure Storage**: Migrate from SharedPreferences to flutter_secure_storage
2. **Certificate Pinning**: Add SSL certificate pinning for production
3. **Request Retry**: Add automatic retry logic for failed requests
4. **Offline Support**: Add request queuing for offline scenarios
5. **Request Cancellation**: Add support for cancelling in-flight requests
6. **Rate Limiting**: Add client-side rate limiting
7. **Request Deduplication**: Prevent duplicate concurrent requests

## Related Files

- `lib/core/errors/failures.dart` - Domain failure types
- `lib/core/constants/app_strings.dart` - Storage keys
- `backend/src/middleware/auth.js` - Backend JWT verification
- `backend/src/utils/jwt.js` - Backend JWT generation

## Requirements Validation

This implementation validates the following requirements:

- **6.1**: Token refresh on expiration
- **6.2**: Refresh token rotation
- **6.5**: Token blacklist checking (backend)
- **6.6**: JWT signature verification (backend)
- **6.7**: User ID and role extraction (backend)
- **6.8**: 401 Unauthorized on invalid tokens
- **8.5**: Request/response logging for debugging
