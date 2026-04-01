# VisaDuma Clean Architecture Guide

## Overview

VisaDuma follows **Clean Architecture** principles with a **feature-first** folder structure. This document explains the architectural decisions, patterns, and best practices used throughout the codebase.

## Architecture Principles

### 1. Separation of Concerns
Each layer has a distinct responsibility:
- **Presentation**: UI and user interaction
- **Domain**: Business logic and rules
- **Data**: Data access and persistence

### 2. Dependency Rule
Dependencies point inward:
```
Presentation → Domain ← Data
     ↓           ↓
   Core    ←    Core
```

- Outer layers depend on inner layers
- Inner layers know nothing about outer layers
- Domain layer is the most stable (no external dependencies)

### 3. Framework Independence
Business logic (domain layer) is independent of:
- Flutter framework
- Third-party libraries
- UI implementation details
- Database implementation

### 4. Testability
Each layer can be tested independently:
- Domain: Pure unit tests
- Data: Tests with mocked data sources
- Presentation: Widget tests with mocked repositories

## Layer Details

### Domain Layer (Business Logic)

**Purpose**: Contains the core business logic and rules.

**Components**:

1. **Entities**: Business objects representing core concepts
   ```dart
   class User {
     final String id;
     final String fullName;
     final String email;
     final UserRole role;
     
     const User({
       required this.id,
       required this.fullName,
       required this.email,
       required this.role,
     });
   }
   ```

2. **Repository Interfaces**: Abstract contracts for data access
   ```dart
   abstract class AuthRepository {
     Future<Either<Failure, User>> login(String email, String password);
     Future<Either<Failure, User>> register(RegisterRequest request);
     Future<Either<Failure, void>> logout();
   }
   ```

3. **Use Cases**: Single-purpose business operations
   ```dart
   class LoginUseCase {
     final AuthRepository repository;
     
     LoginUseCase(this.repository);
     
     Future<Either<Failure, User>> call(String email, String password) {
       return repository.login(email, password);
     }
   }
   ```

**Rules**:
- No Flutter imports (except for rare cases like `@immutable`)
- No third-party library dependencies
- Use `Either` from dartz for error handling
- Entities are immutable

### Data Layer (Data Access)

**Purpose**: Implements data access and persistence.

**Components**:

1. **Models**: JSON-serializable data transfer objects
   ```dart
   @freezed
   class UserModel with _$UserModel {
     const factory UserModel({
       required String id,
       required String fullName,
       required String email,
       required String role,
     }) = _UserModel;
     
     factory UserModel.fromJson(Map<String, dynamic> json) =>
         _$UserModelFromJson(json);
   }
   ```

2. **Data Sources**: API calls and local storage
   ```dart
   abstract class AuthRemoteDataSource {
     Future<UserModel> login(String email, String password);
     Future<UserModel> register(RegisterRequest request);
   }
   
   class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
     final ApiClient apiClient;
     
     AuthRemoteDataSourceImpl(this.apiClient);
     
     @override
     Future<UserModel> login(String email, String password) async {
       final response = await apiClient.post('/auth/login', data: {
         'email': email,
         'password': password,
       });
       return UserModel.fromJson(response.data['data']);
     }
   }
   ```

3. **Repository Implementations**: Concrete implementations
   ```dart
   class AuthRepositoryImpl implements AuthRepository {
     final AuthRemoteDataSource remoteDataSource;
     final AuthLocalDataSource localDataSource;
     
     AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);
     
     @override
     Future<Either<Failure, User>> login(String email, String password) async {
       try {
         final userModel = await remoteDataSource.login(email, password);
         await localDataSource.cacheUser(userModel);
         return Right(userModel.toEntity());
       } catch (e) {
         return Left(ServerFailure(e.toString()));
       }
     }
   }
   ```

**Rules**:
- Models map to/from entities
- Handle all exceptions and convert to `Failure` objects
- Use dependency injection for data sources
- Cache data when appropriate

### Presentation Layer (UI)

**Purpose**: Displays data and handles user interaction.

**Components**:

1. **Screens**: Full-page UI components
   ```dart
   class LoginScreen extends ConsumerWidget {
     const LoginScreen({Key? key}) : super(key: key);
     
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final authState = ref.watch(authViewModelProvider);
       
       return Scaffold(
         appBar: AppBar(title: Text('Login')),
         body: authState.when(
           data: (user) => HomeScreen(),
           loading: () => CircularProgressIndicator(),
           error: (error, stack) => ErrorWidget(error),
         ),
       );
     }
   }
   ```

2. **Widgets**: Reusable UI components
   ```dart
   class AuthFormWidget extends StatelessWidget {
     final Function(String email, String password) onSubmit;
     
     const AuthFormWidget({Key? key, required this.onSubmit}) : super(key: key);
     
     @override
     Widget build(BuildContext context) {
       // Form implementation
     }
   }
   ```

3. **View Models**: State management with Riverpod
   ```dart
   @riverpod
   class AuthViewModel extends _$AuthViewModel {
     @override
     FutureOr<User?> build() async {
       return await ref.read(authRepositoryProvider).getCurrentUser();
     }
     
     Future<void> login(String email, String password) async {
       state = const AsyncLoading();
       final result = await ref.read(loginUseCaseProvider).call(email, password);
       
       result.fold(
         (failure) => state = AsyncError(failure, StackTrace.current),
         (user) => state = AsyncData(user),
       );
     }
   }
   ```

**Rules**:
- Depend only on domain layer (use cases, entities)
- Use Riverpod for state management
- Handle loading, success, and error states
- Keep business logic in domain layer

## State Management with Riverpod

### Provider Types

1. **Provider**: For immutable values
   ```dart
   final apiClientProvider = Provider((ref) => ApiClient());
   ```

2. **StateProvider**: For simple mutable state
   ```dart
   final counterProvider = StateProvider((ref) => 0);
   ```

3. **FutureProvider**: For async operations
   ```dart
   final userProvider = FutureProvider((ref) async {
     return await ref.read(authRepositoryProvider).getCurrentUser();
   });
   ```

4. **StreamProvider**: For streams
   ```dart
   final messagesProvider = StreamProvider((ref) {
     return ref.read(chatRepositoryProvider).getMessageStream();
   });
   ```

5. **StateNotifierProvider**: For complex state
   ```dart
   @riverpod
   class AuthViewModel extends _$AuthViewModel {
     // Implementation
   }
   ```

### Best Practices

- Use code generation (`@riverpod`) for type safety
- Keep providers focused and single-purpose
- Use `ref.watch` in build methods
- Use `ref.read` in event handlers
- Handle `AsyncValue` states properly

## Error Handling

### Failure Classes

```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}
```

### Using Either

```dart
Future<Either<Failure, User>> login(String email, String password) async {
  try {
    final user = await remoteDataSource.login(email, password);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}
```

## Dependency Injection

Use Riverpod for dependency injection:

```dart
// Data sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(apiClientProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(authLocalDataSourceProvider),
  );
});

// Use cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});
```

## Code Generation

### Setup

Add to `pubspec.yaml`:
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  riverpod_annotation: ^2.3.0

dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.0
```

### Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Testing Strategy

### Unit Tests (Domain Layer)

```dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  test('should return User when login is successful', () async {
    // Arrange
    when(mockRepository.login(any, any))
        .thenAnswer((_) async => Right(tUser));
    
    // Act
    final result = await useCase('test@example.com', 'password');
    
    // Assert
    expect(result, Right(tUser));
    verify(mockRepository.login('test@example.com', 'password'));
  });
}
```

### Widget Tests (Presentation Layer)

```dart
void main() {
  testWidgets('should display loading indicator when state is loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith((ref) => AsyncLoading()),
        ],
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

## Performance Optimization

### 1. Lazy Loading
Load data only when needed:
```dart
@riverpod
Future<List<Product>> products(Ref ref, int page) async {
  return await ref.read(productsRepositoryProvider).getProducts(page);
}
```

### 2. Caching
Cache frequently accessed data:
```dart
@riverpod
Future<User> currentUser(Ref ref) async {
  // Cache for 5 minutes
  ref.cacheFor(Duration(minutes: 5));
  return await ref.read(authRepositoryProvider).getCurrentUser();
}
```

### 3. Pagination
Implement pagination for large lists:
```dart
class ProductsViewModel extends StateNotifier<AsyncValue<List<Product>>> {
  int _currentPage = 1;
  bool _hasMore = true;
  
  Future<void> loadMore() async {
    if (!_hasMore) return;
    
    _currentPage++;
    final newProducts = await repository.getProducts(_currentPage);
    
    if (newProducts.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...state.value!, ...newProducts]);
    }
  }
}
```

## Security Best Practices

1. **Never store sensitive data in plain text**
2. **Use secure storage for tokens**
3. **Validate all user inputs**
4. **Implement proper authentication**
5. **Use HTTPS for all API calls**
6. **Sanitize data before display**
7. **Implement rate limiting**
8. **Handle errors gracefully without exposing internals**

## Localization

Support for English, Sinhala, and Tamil:

```dart
class AppLocalizations {
  static String translate(BuildContext context, String key) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!.get(key);
  }
}

// Usage
Text(AppLocalizations.translate(context, 'login.title'))
```

## Conclusion

This architecture provides:
- **Maintainability**: Clear separation of concerns
- **Testability**: Each layer can be tested independently
- **Scalability**: Easy to add new features
- **Flexibility**: Easy to change implementations
- **Team Collaboration**: Clear boundaries for parallel development

Follow these guidelines to maintain consistency and quality across the codebase.
