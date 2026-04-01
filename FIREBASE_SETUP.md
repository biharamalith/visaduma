# Firebase Setup Guide for VisaDuma

This guide walks you through setting up Firebase Cloud Messaging (FCM) for push notifications in the VisaDuma app.

## Prerequisites

- A Google account
- Access to the [Firebase Console](https://console.firebase.google.com/)
- Flutter development environment set up
- Android Studio (for Android) and/or Xcode (for iOS)

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click **Add project** or select an existing project
3. Enter your project name (e.g., "VisaDuma")
4. (Optional) Enable Google Analytics
5. Click **Create project**

## Step 2: Add Firebase to Your Flutter App

### Install Firebase CLI

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### Configure Firebase for Flutter

```bash
# Run this command in your project root directory
flutterfire configure

# Select your Firebase project
# Select platforms: Android, iOS
# This will generate firebase_options.dart file
```

This command will:
- Create `firebase_options.dart` in your `lib/` directory
- Download and place configuration files for Android and iOS
- Update your `pubspec.yaml` if needed

## Step 3: Add Firebase Core Dependency

Add `firebase_core` to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_messaging: ^15.1.5  # Already added
  flutter_local_notifications: ^17.2.1+2  # Already added
```

Run:
```bash
flutter pub get
```

## Step 4: Android Configuration

### 4.1 Add google-services.json

1. In Firebase Console, go to **Project Settings** > **Your apps**
2. Click the Android icon to add an Android app
3. Enter your Android package name: `com.visaduma.app` (or your actual package name from `android/app/build.gradle.kts`)
4. Download `google-services.json`
5. Place it in `android/app/` directory

### 4.2 Update Android Build Files

**android/build.gradle.kts** - Add Google services plugin:

```kotlin
buildscript {
    dependencies {
        // Add this line
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

**android/app/build.gradle.kts** - Apply the plugin at the bottom:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ... rest of the file ...

// Add this at the very bottom
apply(plugin = "com.google.gms.google-services")
```

### 4.3 Update AndroidManifest.xml

Add these permissions and services to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>

    <application
        android:label="visaduma"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Existing activity configuration -->
        <activity ...>
            ...
        </activity>

        <!-- Add Firebase Messaging Service -->
        <service
            android:name="com.google.firebase.messaging.FirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>

        <!-- Default notification channel (optional) -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="system_alerts" />

        <!-- Existing meta-data -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

## Step 5: iOS Configuration

### 5.1 Add GoogleService-Info.plist

1. In Firebase Console, go to **Project Settings** > **Your apps**
2. Click the iOS icon to add an iOS app
3. Enter your iOS bundle ID: `com.visaduma.app` (or your actual bundle ID from `ios/Runner.xcodeproj`)
4. Download `GoogleService-Info.plist`
5. Open `ios/Runner.xcworkspace` in Xcode
6. Drag `GoogleService-Info.plist` into the `Runner` folder in Xcode
7. Make sure "Copy items if needed" is checked
8. Select the Runner target

### 5.2 Enable Push Notifications Capability

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the navigator
3. Select the **Runner** target
4. Go to **Signing & Capabilities** tab
5. Click **+ Capability**
6. Add **Push Notifications**
7. Add **Background Modes** and check:
   - Remote notifications
   - Background fetch

### 5.3 Update AppDelegate.swift

Update `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()
    
    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle FCM token registration
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
}
```

### 5.4 Create APNs Key (Required for iOS)

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Keys** in the sidebar
4. Click the **+** button to create a new key
5. Enter a name (e.g., "VisaDuma APNs Key")
6. Check **Apple Push Notifications service (APNs)**
7. Click **Continue** and then **Register**
8. Download the `.p8` key file (you can only download it once!)
9. Note the **Key ID**

### 5.5 Upload APNs Key to Firebase

1. In Firebase Console, go to **Project Settings**
2. Select the **Cloud Messaging** tab
3. Scroll to **Apple app configuration**
4. Under **APNs Authentication Key**, click **Upload**
5. Upload your `.p8` file
6. Enter your **Key ID** and **Team ID** (found in Apple Developer Portal)
7. Click **Upload**

## Step 6: Update main.dart

Update your `lib/main.dart` to initialize Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _initializeFirebase() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize notification service
    await NotificationService.instance.initialize();
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}
```

## Step 7: Test Push Notifications

### Test from Firebase Console

1. Go to Firebase Console > **Cloud Messaging**
2. Click **Send your first message**
3. Enter notification title and text
4. Click **Send test message**
5. Enter your FCM token (printed in debug console when app runs)
6. Click **Test**

### Test from Code

Run the app and check the debug console for:
```
FCM Token: <your-token-here>
NotificationService initialized successfully
```

## Step 8: Backend Integration

### Register FCM Token with Backend

When a user logs in, register their FCM token:

```dart
// After successful login
final userId = user.id;
await NotificationService.instance.registerToken(userId);
```

### Backend API Endpoint

Create an endpoint to store FCM tokens:

```javascript
// POST /api/v1/notifications/register-token
{
  "user_id": "user-uuid",
  "fcm_token": "fcm-token-string",
  "device_type": "android" | "ios"
}
```

### Send Notifications from Backend

Use Firebase Admin SDK to send notifications:

```javascript
const admin = require('firebase-admin');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Send notification
await admin.messaging().send({
  token: fcmToken,
  notification: {
    title: 'Ride Confirmed',
    body: 'Your driver is on the way!'
  },
  data: {
    type: 'ride_updates',
    ride_id: 'ride-uuid',
    reference_type: 'ride',
    reference_id: 'ride-uuid'
  },
  android: {
    priority: 'high',
    notification: {
      channelId: 'ride_updates'
    }
  },
  apns: {
    payload: {
      aps: {
        badge: 1,
        sound: 'default'
      }
    }
  }
});
```

## Notification Channels

The app supports these notification channels:

| Channel ID | Name | Description | Importance |
|------------|------|-------------|------------|
| `ride_updates` | Ride Updates | Ride status updates | High |
| `order_updates` | Order Updates | Order status updates | High |
| `booking_updates` | Booking Updates | Booking status updates | High |
| `payment_updates` | Payment Updates | Payment transactions | High |
| `chat_messages` | Chat Messages | New chat messages | High |
| `system_alerts` | System Alerts | Important system notifications | Max |
| `promotions` | Promotions | Promotional offers | Default |

## Handling Notification Taps

Listen to notification tap events in your app:

```dart
// In your root widget or router
NotificationService.instance.onNotificationTap.listen((data) {
  final referenceType = data['reference_type'];
  final referenceId = data['reference_id'];
  
  // Navigate based on notification type
  switch (referenceType) {
    case 'ride':
      context.go('/rides/$referenceId');
      break;
    case 'order':
      context.go('/orders/$referenceId');
      break;
    case 'booking':
      context.go('/bookings/$referenceId');
      break;
    // ... handle other types
  }
});
```

## Troubleshooting

### Android Issues

**Issue**: Notifications not received
- Check `google-services.json` is in `android/app/`
- Verify package name matches in Firebase Console
- Check internet permission in AndroidManifest.xml
- Rebuild the app: `flutter clean && flutter run`

**Issue**: Build fails with "google-services plugin" error
- Ensure `google-services` plugin is added to both build.gradle files
- Check Gradle version compatibility

### iOS Issues

**Issue**: Notifications not received
- Verify `GoogleService-Info.plist` is added to Xcode project
- Check Push Notifications capability is enabled
- Verify APNs key is uploaded to Firebase
- Check bundle ID matches in Firebase Console

**Issue**: "Missing Push Notification Entitlement" warning
- Enable Push Notifications capability in Xcode
- Clean and rebuild: `flutter clean && flutter run`

### General Issues

**Issue**: FCM token is null
- Check internet connection
- Verify Firebase is initialized before getting token
- Check Firebase configuration files are present

**Issue**: Notifications work in foreground but not background
- Verify background message handler is set up
- Check app has necessary permissions
- For iOS, verify Background Modes capability is enabled

## Security Best Practices

1. **Never commit Firebase config files to public repositories**
   - Add to `.gitignore`:
     ```
     # Firebase
     android/app/google-services.json
     ios/Runner/GoogleService-Info.plist
     lib/firebase_options.dart
     ```

2. **Use environment-specific Firebase projects**
   - Development project for testing
   - Production project for live app

3. **Implement server-side token validation**
   - Verify FCM tokens on your backend
   - Deactivate invalid/expired tokens

4. **Rate limit notification sending**
   - Prevent spam and abuse
   - Respect user preferences

## Next Steps

1. ✅ Complete Firebase setup for Android and iOS
2. ✅ Test notifications on physical devices
3. ⬜ Implement backend API for token registration
4. ⬜ Add notification preferences UI
5. ⬜ Implement deep linking for notification taps
6. ⬜ Set up notification analytics and monitoring

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

## Support

For issues or questions:
- Check Firebase Console logs
- Review Flutter debug console output
- Consult FlutterFire GitHub issues
- Contact the development team
