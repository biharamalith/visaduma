# VisaDuma Flutter Folder Structure

## Complete Directory Tree

```
lib/
├── core/                           # Shared infrastructure
│   ├── constants/                  # App-wide constants and enums
│   │   ├── constants.dart         # Barrel export
│   │   └── .gitkeep
│   ├── localization/              # i18n support (EN, SI, TA)
│   │   ├── localization.dart      # Barrel export
│   │   └── .gitkeep
│   ├── network/                   # HTTP client and API config
│   │   ├── network.dart           # Barrel export
│   │   └── .gitkeep
│   ├── storage/                   # Local storage utilities
│   │   ├── storage.dart           # Barrel export
│   │   └── .gitkeep
│   ├── theme/                     # Theme, colors, typography
│   │   ├── theme.dart             # Barrel export
│   │   └── .gitkeep
│   ├── utils/                     # Helper functions and extensions
│   │   ├── utils.dart             # Barrel export
│   │   └── .gitkeep
│   ├── core.dart                  # Main core barrel export
│   └── README.md                  # Core documentation
│
├── features/                       # Feature modules (feature-first)
│   ├── auth/                      # Authentication & authorization
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── auth.dart              # Feature barrel export
│   │
│   ├── rides/                     # Ride-hailing service
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── rides.dart
│   │
│   ├── shops/                     # E-commerce marketplace
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── shops.dart
│   │
│   ├── services/                  # On-demand services
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── services.dart
│   │
│   ├── bookings/                  # Service booking management
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── bookings.dart
│   │
│   ├── wallet/                    # VisaPay digital wallet
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── wallet.dart
│   │
│   ├── chat/                      # Real-time messaging
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── chat.dart
│   │
│   ├── notifications/             # Push notifications
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── notifications.dart
│   │
│   ├── reviews/                   # Ratings and reviews
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── reviews.dart
│   │
│   ├── jobs/                      # Job marketplace
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── jobs.dart
│   │
│   ├── vehicles/                  # Vehicle rental marketplace
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── vehicles.dart
│   │
│   ├── loyalty/                   # Loyalty program
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── loyalty.dart
│   │
│   ├── recommendations/           # AI recommendations
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── recommendations.dart
│   │
│   ├── maps/                      # Maps integration
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── maps.dart
│   │
│   ├── provider/                  # Service provider management
│   │   ├── data/
│   │   │   ├── data.dart
│   │   │   └── .gitkeep
│   │   ├── domain/
│   │   │   ├── domain.dart
│   │   │   └── .gitkeep
│   │   ├── presentation/
│   │   │   ├── presentation.dart
│   │   │   └── .gitkeep
│   │   └── provider.dart
│   │
│   └── README.md                  # Features documentation
│
├── l10n/                          # Localization files
│   ├── app_en.arb                # English translations
│   ├── app_si.arb                # Sinhala translations
│   ├── app_ta.arb                # Tamil translations
│   └── app_localizations.dart
│
├── shared/                        # Shared widgets and components
│   ├── models/
│   ├── providers/
│   └── widgets/
│
├── ARCHITECTURE.md                # Architecture guide
├── README.md                      # Main documentation
└── main.dart                      # Application entry point
```

## Layer Structure (Per Feature)

Each feature follows this internal structure:

```
feature_name/
├── data/                          # Data Layer
│   ├── datasources/              # API and local data sources
│   │   ├── feature_remote_datasource.dart
│   │   └── feature_local_datasource.dart
│   ├── models/                   # JSON serializable models
│   │   └── feature_model.dart
│   ├── repositories/             # Repository implementations
│   │   └── feature_repository_impl.dart
│   └── data.dart                 # Barrel export
│
├── domain/                        # Domain Layer
│   ├── entities/                 # Business entities
│   │   └── feature_entity.dart
│   ├── repositories/             # Repository interfaces
│   │   └── feature_repository.dart
│   ├── usecases/                 # Business logic
│   │   ├── get_feature_usecase.dart
│   │   └── create_feature_usecase.dart
│   └── domain.dart               # Barrel export
│
├── presentation/                  # Presentation Layer
│   ├── screens/                  # Full-page UI components
│   │   └── feature_screen.dart
│   ├── widgets/                  # Reusable UI components
│   │   └── feature_widget.dart
│   ├── viewmodels/               # State management
│   │   └── feature_viewmodel.dart
│   └── presentation.dart         # Barrel export
│
└── feature_name.dart             # Main feature barrel export
```

## Statistics

- **Total Features**: 15
- **Core Modules**: 6
- **Layers per Feature**: 3 (data, domain, presentation)
- **Total Feature Layers**: 45
- **Barrel Export Files**: 22
- **Documentation Files**: 4

## Import Examples

### Import entire feature:
```dart
import 'package:visaduma/features/auth/auth.dart';
```

### Import specific layer:
```dart
import 'package:visaduma/features/auth/domain/domain.dart';
```

### Import core utilities:
```dart
import 'package:visaduma/core/core.dart';
```

### Import specific core module:
```dart
import 'package:visaduma/core/network/network.dart';
```

## Architecture Compliance

✅ **Clean Architecture**: Three-layer separation (data/domain/presentation)  
✅ **Feature-First**: Self-contained feature modules  
✅ **Dependency Rule**: Dependencies point inward  
✅ **Barrel Exports**: Clean import statements  
✅ **Documentation**: Comprehensive guides and READMEs  
✅ **Scalability**: Easy to add new features  
✅ **Maintainability**: Clear structure and organization  

## Next Steps

1. Implement domain layer (entities, repositories, use cases)
2. Implement data layer (models, data sources, repository implementations)
3. Implement presentation layer (screens, widgets, view models)
4. Write tests for each layer
5. Generate code with build_runner
