# Core Services

This directory contains singleton services that provide cross-cutting functionality across the app.

## Services

### NotificationService

**File**: `notification_service.dart`

**Purpose**: Manages Firebase Cloud Messaging (FCM) for push notifications.

**Features**:
- Firebase initialization and configuration
- FCM token registration and refresh handling
- Notification permission requests
- Foreground notification display using local notifications
- Background notification handling
- Notification tap event handling with deep linking
- Android notification channels for different notification types
- iOS badge and sound configuration

**Usage**:

```dart
// Initialize (called in main.dart)
await NotificationService.instance.initialize();

// Register FCM token with backend after login
await NotificationService.instance.registerToken(userId);

// Listen to notification taps
NotificationService.instance.onNotificationTap.listen((data) {
  final referenceType = data['reference_type'];
  final referenceId = data['reference_id'];
  
  // Navigate to relevant screen
  switch (referenceType) {
    case 'ride':
      context.go('/rides/$referenceId');
      break;
    case 'order':
      context.go('/orders/$referenceId');
      break;
    // ... handle other types
  }
});

// Get current FCM token
final token = NotificationService.instance.fcmToken;
```

**Notification Channels**:

| Channel ID | Purpose | Importance |
|------------|---------|------------|
| `ride_updates` | Ride status updates | High |
| `order_updates` | Order status updates | High |
| `booking_updates` | Booking status updates | High |
| `payment_updates` | Payment transactions | High |
| `chat_messages` | New chat messages | High |
| `system_alerts` | Critical system notifications | Max |
| `promotions` | Promotional offers | Default |

**Requirements Satisfied**:
- Requirement 30.1: Firebase Cloud Messaging integration
- Requirement 30.2: Notification permission requests
- Requirement 30.3: FCM token registration
- Requirement 30.4: Notification channels for Android

**Setup Required**:
1. Add Firebase configuration files (see `FIREBASE_SETUP.md`)
2. Add `firebase_core` dependency to `pubspec.yaml`
3. Uncomment Firebase initialization in `main.dart`
4. Configure Android and iOS projects (see `FIREBASE_CHECKLIST.md`)

## Adding New Services

When adding a new service to this directory:

1. **Create a singleton class**:
   ```dart
   class MyService {
     MyService._();
     static final MyService instance = MyService._();
     
     // Service implementation
   }
   ```

2. **Initialize in main.dart** if needed:
   ```dart
   await MyService.instance.initialize();
   ```

3. **Document the service** in this README

4. **Follow clean architecture principles**:
   - Services should be independent of features
   - Services should not depend on UI/presentation layer
   - Services should provide clear, focused functionality

## Best Practices

- Use singleton pattern for services that need global access
- Initialize services in `main.dart` before running the app
- Handle errors gracefully and log them for debugging
- Dispose resources properly when services are no longer needed
- Keep services focused on a single responsibility
- Document public APIs clearly
- Write unit tests for service logic

## Future Services

Potential services to add:

- **SocketService**: WebSocket connection management for real-time features
- **LocationService**: GPS location tracking and geofencing
- **AnalyticsService**: Event tracking and analytics
- **CrashReportingService**: Error reporting and crash analytics
- **BiometricService**: Biometric authentication (fingerprint, face ID)
- **DeepLinkService**: Deep link handling and routing
- **CacheService**: Advanced caching strategies
- **SyncService**: Offline data synchronization
