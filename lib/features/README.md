# Features Module

This directory contains all feature modules following a **feature-first** architecture approach. Each feature is self-contained with its own data, domain, and presentation layers.

## Feature Modules

### Core Services
- **auth**: User authentication, registration, and session management
- **wallet**: VisaPay digital wallet for payments and transactions
- **notifications**: Push notifications and in-app alerts
- **chat**: Real-time messaging between users and providers

### Marketplace Features
- **rides**: Ride-hailing service (Uber-like functionality)
- **shops**: E-commerce marketplace for products
- **services**: On-demand services booking
- **jobs**: Job marketplace and gig opportunities
- **vehicles**: Vehicle rental marketplace

### Supporting Features
- **bookings**: Service booking scheduling and management
- **reviews**: Ratings and reviews for services/products
- **loyalty**: Loyalty program with points and rewards
- **recommendations**: AI-powered recommendations
- **maps**: Maps integration and location services
- **provider**: Service provider profile management

## Feature Structure

Each feature follows this structure:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_datasource.dart
│   │   └── feature_local_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   ├── repositories/
│   │   └── feature_repository_impl.dart
│   └── data.dart (barrel export)
│
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   ├── usecases/
│   │   └── get_feature_usecase.dart
│   └── domain.dart (barrel export)
│
├── presentation/
│   ├── screens/
│   │   └── feature_screen.dart
│   ├── widgets/
│   │   └── feature_widget.dart
│   ├── viewmodels/
│   │   └── feature_viewmodel.dart
│   └── presentation.dart (barrel export)
│
└── feature_name.dart (main barrel export)
```

## Layer Responsibilities

### Data Layer
- Fetches data from remote APIs
- Caches data locally
- Implements repository interfaces from domain layer
- Handles data serialization/deserialization

### Domain Layer
- Defines business entities
- Declares repository interfaces
- Contains use cases (business logic)
- Framework-independent (pure Dart)

### Presentation Layer
- UI screens and widgets
- State management with Riverpod
- User interaction handling
- Depends only on domain layer

## Creating a New Feature

1. Create the feature folder structure:
   ```
   lib/features/new_feature/
   ├── data/
   ├── domain/
   └── presentation/
   ```

2. Create barrel export files:
   - `data/data.dart`
   - `domain/domain.dart`
   - `presentation/presentation.dart`
   - `new_feature.dart`

3. Implement layers in order:
   - Domain (entities, repositories, use cases)
   - Data (models, data sources, repository implementations)
   - Presentation (screens, widgets, view models)

4. Export public APIs in barrel files

## Best Practices

- Keep features independent (minimal cross-feature dependencies)
- Use dependency injection for testability
- Follow single responsibility principle
- Write tests for each layer
- Use meaningful names for files and classes
- Document complex business logic

## Feature Dependencies

Features can depend on:
- Core infrastructure (`lib/core/`)
- Shared components (`lib/shared/`)
- Other feature's domain layer (avoid when possible)

Features should NOT depend on:
- Other feature's data or presentation layers
- Implementation details of other features

## Testing

Each feature should have:
- Unit tests for domain layer (use cases, entities)
- Unit tests for data layer (repositories, models)
- Widget tests for presentation layer
- Integration tests for critical flows

Test files mirror the source structure:
```
test/features/feature_name/
├── data/
├── domain/
└── presentation/
```
