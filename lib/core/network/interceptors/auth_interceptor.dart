// ============================================================
// FILE: lib/core/network/interceptors/auth_interceptor.dart
// PURPOSE: Dio interceptor for JWT token injection.
//          Automatically adds Bearer token to all requests.
//          Validates: Requirements 6.6, 6.7, 67.3, 67.4
// ============================================================

import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';

/// Interceptor that injects JWT Bearer token into request headers.
/// 
/// This interceptor:
/// - Retrieves the access token from SecureStorageService
/// - Adds Authorization header with Bearer token to all requests
/// - Sets Accept and Content-Type headers for JSON communication
/// - Uses secure storage instead of SharedPreferences for tokens
class AuthInterceptor extends Interceptor {
  AuthInterceptor({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  final SecureStorageService _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Retrieve stored access token from secure storage
    final token = await _secureStorage.getAccessToken();

    // Inject Bearer token if available
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Set standard headers for JSON API communication
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    handler.next(options);
  }
}
