# Core Infrastructure

This directory contains shared infrastructure code used across all features. Core modules provide foundational functionality like networking, storage, theming, and utilities.

## Core Modules

### constants/
App-wide constants, enums, and configuration values.

**Contents:**
- API endpoints and base URLs
- App configuration constants
- Enums for app-wide types
- Feature flags

**Example:**
```dart
class ApiConstants {
  static const String baseUrl = 'https://api.visaduma.lk';
  static const String apiVersion = 'v1';
}

enum UserRole { user, provider, shopOwner, admin }
```

### localization/
Internationalization (i18n) support for English, Sinhala, and Tamil.

**Contents:**
- AppLocalizations class
- Language manager
- Translation utilities

**Example:**
```dart
class AppLocalizations {
  static String translate(BuildContext context, String key) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!.get(key);
  }
}
```

### network/
HTTP client configuration and API communication.

**Contents:**
- Dio client setup
- API interceptors (auth, logging, error handling)
- Network error handling
- Request/response models

**Example:**
```dart
class ApiClient {
  final Dio _dio;
  
  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  )) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }
}
```

### storage/
Local data persistence utilities.

**Contents:**
- SharedPreferences wrapper
- Secure storage for sensitive data
- Cache management
- Local database (if needed)

**Example:**
```dart
class LocalStorage {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
```

### theme/
App theming, colors, typography, and styling.

**Contents:**
- Light and dark themes
- Color palette
- Typography styles
- Spacing and dimensions

**Example:**
```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTypography.textTheme,
  );
}
```

### utils/
Helper functions, extensions, and utilities.

**Contents:**
- String extensions
- Date/time utilities
- Validators
- Formatters
- Common helpers

**Example:**
```dart
extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}
```

## Usage

Import core modules using barrel exports:

```dart
import 'package:visaduma/core/core.dart';
```

Or import specific modules:

```dart
import 'package:visaduma/core/network/network.dart';
import 'package:visaduma/core/theme/theme.dart';
```

## Design Principles

### 1. Framework Independence
Core utilities should be framework-agnostic where possible. Avoid tight coupling to Flutter widgets.

### 2. Reusability
Code in core should be reusable across multiple features. Feature-specific code belongs in feature modules.

### 3. Single Responsibility
Each core module has a clear, focused purpose. Don't create "god" utility classes.

### 4. Testability
All core utilities should be easily testable with unit tests.

## Best Practices

- Keep core modules lightweight
- Avoid feature-specific logic in core
- Document public APIs
- Write unit tests for utilities
- Use dependency injection for testability
- Follow Dart style guide

## Adding New Core Modules

1. Create a new directory under `lib/core/`
2. Add implementation files
3. Create a barrel export file (`module_name.dart`)
4. Export from `lib/core/core.dart`
5. Document the module in this README

## Testing

Core utilities should have comprehensive unit tests:

```
test/core/
├── constants/
├── localization/
├── network/
├── storage/
├── theme/
└── utils/
```

Run core tests:
```bash
flutter test test/core/
```

## Dependencies

Core modules can depend on:
- Dart standard library
- Flutter framework (when necessary)
- Third-party packages (dio, shared_preferences, etc.)

Core modules should NOT depend on:
- Feature modules
- Presentation layer code
- Business logic
