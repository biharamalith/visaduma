# VisaDuma Flutter Application

## Architecture Overview

This Flutter application follows **Clean Architecture** principles with a **feature-first** folder structure. The codebase is organized into independent feature modules and shared core infrastructure.

## Folder Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── constants/          # App-wide constants and enums
│   ├── localization/       # i18n support (English, Sinhala, Tamil)
│   ├── network/            # HTTP client and API configuration
│   ├── storage/            # Local storage utilities
│   ├── theme/              # Theme, colors, typography
│   └── utils/              # Helper functions and extensions
│
├── features/               # Feature modules (feature-first)
│   ├── auth/              # Authentication & authorization
│   ├── rides/             # Ride-hailing service
│   ├── shops/             # E-commerce marketplace
│   ├── services/          # On-demand services
│   ├── bookings/          # Service booking management
│   ├── wallet/            # VisaPay digital wallet
│   ├── chat/              # Real-time messaging
│   ├── notifications/     # Push notifications
│   ├── reviews/           # Ratings and reviews
│   ├── jobs/              # Job marketplace
│   ├── vehicles/          # Vehicle rental marketplace
│   ├── loyalty/           # Loyalty program
│   ├── recommendations/   # AI recommendations
│   ├── maps/              # Maps integration
│   └── provider/          # Service provider management
│
├── l10n/                   # Localization files
├── shared/                 # Shared widgets and components
└── main.dart              # Application entry point
```

## Clean Architecture Layers

Each feature module follows clean architecture with three layers:

### 1. Data Layer (`data/`)
- **Data Sources**: Remote API calls and local storage
- **Models**: JSON serializable data models
- **Repository Implementations**: Concrete implementations of domain repositories

### 2. Domain Layer (`domain/`)
- **Entities**: Business objects (immutable, framework-independent)
- **Repository Interfaces**: Abstract contracts for data access
- **Use Cases**: Business logic and application rules

### 3. Presentation Layer (`presentation/`)
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components
- **View Models**: State management with Riverpod

## Dependency Flow

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has no dependencies (pure business logic)

## State Management

This app uses **Riverpod** for state management:
- `@riverpod` code generation for providers
- `AsyncValue` for handling loading/error states
- `StateNotifier` for complex state logic

## Key Technologies

- **State Management**: Riverpod
- **Navigation**: go_router
- **Networking**: Dio
- **Real-time**: socket_io_client
- **Localization**: intl
- **Functional Programming**: dartz
- **Code Generation**: freezed, json_serializable

## Module Exports

Each feature has a barrel export file (e.g., `auth/auth.dart`) that exports all public APIs:

```dart
import 'package:visaduma/features/auth/auth.dart';
```

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful names for variables and functions
- Add comments for complex logic
- Maintain 80% code coverage for tests

## Testing

- Unit tests for business logic (domain layer)
- Widget tests for UI components
- Integration tests for critical flows

Run tests:
```bash
flutter test
```

## Contributing

1. Create feature branch from `develop`
2. Follow clean architecture principles
3. Write tests for new features
4. Submit pull request for code review
