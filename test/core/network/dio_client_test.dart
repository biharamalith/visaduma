// ============================================================
// FILE: test/core/network/dio_client_test.dart
// PURPOSE: Unit tests for DioClient configuration
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:visaduma/core/network/api_endpoints.dart';
import 'package:visaduma/core/network/dio_client.dart';

void main() {
  group('DioClient', () {
    test('should create a singleton Dio instance', () {
      // Arrange & Act
      final dio1 = DioClient.instance;
      final dio2 = DioClient.instance;

      // Assert
      expect(dio1, same(dio2));
    });

    test('should configure base URL correctly', () {
      // Arrange & Act
      final dio = DioClient.instance;

      // Assert
      expect(dio.options.baseUrl, equals(ApiEndpoints.baseUrl));
    });

    test('should configure timeouts correctly', () {
      // Arrange & Act
      final dio = DioClient.instance;

      // Assert
      expect(
        dio.options.connectTimeout?.inMilliseconds,
        equals(ApiEndpoints.connectTimeoutMs),
      );
      expect(
        dio.options.receiveTimeout?.inMilliseconds,
        equals(ApiEndpoints.receiveTimeoutMs),
      );
      expect(
        dio.options.sendTimeout?.inMilliseconds,
        equals(ApiEndpoints.sendTimeoutMs),
      );
    });

    test('should have interceptors configured', () {
      // Arrange & Act
      final dio = DioClient.instance;

      // Assert
      // Should have at least 3 interceptors (Auth, RefreshToken, Error)
      // In debug mode, it will have 4 (including Logging)
      expect(dio.interceptors.length, greaterThanOrEqualTo(3));
    });

    test('should reset Dio instance', () {
      // Arrange
      final dio1 = DioClient.instance;

      // Act
      DioClient.reset();
      final dio2 = DioClient.instance;

      // Assert
      expect(dio1, isNot(same(dio2)));
    });
  });
}
