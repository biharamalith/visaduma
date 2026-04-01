# Firebase Push Notifications - Quick Start

**⚡ Get push notifications working in 15 minutes**

This is a condensed guide for experienced developers. For detailed instructions, see `FIREBASE_SETUP.md`.

## Prerequisites

- Firebase account
- Flutter project set up
- Android Studio / Xcode installed

## 1. Install Tools (2 minutes)

```bash
# Install Firebase CLI
npm install -g firebase-tools
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

## 2. Configure Firebase (3 minutes)

```bash
# In your project root
flutterfire configure

# Select your Firebase project (or create new)
# Select platforms: Android, iOS
# This generates firebase_options.dart and downloads config files
```

## 3. Add Dependencies (1 minute)

Add to `pubspec.yaml`:
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

## 4. Android Setup (3 minutes)

### 4.1 Update `android/build.gradle.kts`:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

### 4.2 Update `android/app/build.gradle.kts` (add at bottom):
```kotlin
apply(plugin = "com.google.gms.google-services")
```

### 4.3 Update `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application ...>
        <!-- Add Firebase Messaging Service -->
        <service
            android:name="com.google.firebase.messaging.FirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
    </application>
</manifest>
```

## 5. iOS Setup (4 minutes)

### 5.1 Open Xcode:
```bash
open ios/Runner.xcworkspace
```

### 5.2 Add Capabilities:
- Select Runner target → Signing & Capabilities
- Add **Push Notifications**
- Add **Background Modes** → Check "Remote notifications"

### 5.3 Update `ios/Runner/AppDelegate.swift`:
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
    FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    }
    
    application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
}
```

### 5.4 Create APNs Key:
1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Certificates, Identifiers & Profiles → Keys → + button
3. Name it, check "Apple Push Notifications service (APNs)"
4. Download `.p8` file (save it!)
5. Upload to Firebase Console → Project Settings → Cloud Messaging → APNs Authentication Key

## 6. Update Code (1 minute)

In `lib/main.dart`, uncomment Firebase initialization:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _initializeFirebase() async {
  try {
    // Uncomment these lines:
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationService.instance.initialize();
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}
```

## 7. Test (1 minute)

```bash
flutter clean
flutter pub get
flutter run
```

Check debug console for:
```
FCM Token: <your-token>
NotificationService initialized successfully
```

## 8. Send Test Notification

1. Firebase Console → Cloud Messaging → "Send your first message"
2. Enter title and body
3. Click "Send test message"
4. Paste your FCM token from debug console
5. Click "Test"

## Done! 🎉

Your app now receives push notifications!

## Next Steps

1. **Backend Integration**: See `FIREBASE_BACKEND_INTEGRATION.md`
2. **Deep Linking**: Implement navigation from notification taps
3. **Preferences**: Add UI for notification settings

## Troubleshooting

### Android
- **No notifications**: Check `google-services.json` package name matches `android/app/build.gradle.kts`
- **Build fails**: Ensure Google services plugin is applied in both gradle files

### iOS
- **No notifications**: Upload APNs key to Firebase Console
- **Build fails**: Check `GoogleService-Info.plist` is in Xcode project

### Both
- **Token is null**: Check internet connection and Firebase initialization
- **Still stuck**: See detailed guide in `FIREBASE_SETUP.md`

## Quick Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get && flutter run

# Check for issues
flutter doctor
flutter analyze

# View logs
flutter logs

# Build release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Files Created

- ✅ `lib/core/services/notification_service.dart` - Notification service
- ✅ `lib/firebase_options.dart` - Generated by flutterfire configure
- ✅ `android/app/google-services.json` - Downloaded from Firebase
- ✅ `ios/Runner/GoogleService-Info.plist` - Downloaded from Firebase

## Important Notes

⚠️ **Never commit these files to public repos**:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

They're already in `.gitignore` ✅

## Need Help?

- 📖 Detailed Guide: `FIREBASE_SETUP.md`
- ✅ Checklist: `FIREBASE_CHECKLIST.md`
- 🔧 Backend: `FIREBASE_BACKEND_INTEGRATION.md`
- 📝 Summary: `FIREBASE_IMPLEMENTATION_SUMMARY.md`

---

**Time to complete**: ~15 minutes  
**Difficulty**: Easy  
**Prerequisites**: Basic Firebase knowledge
