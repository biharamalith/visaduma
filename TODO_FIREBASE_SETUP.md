# Firebase Setup - Action Items for User

This file lists the **required actions** that must be completed by the user to enable push notifications. The code implementation is complete, but Firebase requires manual configuration steps.

## ✅ Already Completed (by Implementation)

- [x] Created `NotificationService` class in `lib/core/services/notification_service.dart`
- [x] Updated `lib/main.dart` to initialize Firebase and notification service
- [x] Added Firebase config files to `.gitignore`
- [x] Created comprehensive documentation
- [x] Implemented notification channels for Android
- [x] Implemented foreground/background notification handling
- [x] Implemented notification tap handling with streams

## ⬜ Required User Actions

### 1. Firebase Project Setup

- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Create a new Firebase project (or select existing)
- [ ] Enable Cloud Messaging in the project

### 2. Install Required Tools

```bash
# Install Firebase CLI
npm install -g firebase-tools
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### 3. Add firebase_core Dependency

Update `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.8.1  # Add this line
  firebase_messaging: ^15.1.5  # Already present
  flutter_local_notifications: ^17.2.1+2  # Already present
```

Then run:
```bash
flutter pub get
```

### 4. Configure Firebase for Flutter

```bash
# Run in project root directory
flutterfire configure

# Follow the prompts:
# - Select your Firebase project
# - Select platforms: Android, iOS
# - This will generate lib/firebase_options.dart
```

### 5. Android Configuration

#### 5.1 Download google-services.json
- [ ] In Firebase Console, add Android app
- [ ] Enter package name from `android/app/build.gradle.kts`
- [ ] Download `google-services.json`
- [ ] Place in `android/app/` directory

#### 5.2 Update android/build.gradle.kts
Add to `buildscript` dependencies:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

#### 5.3 Update android/app/build.gradle.kts
Add at the very bottom:
```kotlin
apply(plugin = "com.google.gms.google-services")
```

#### 5.4 Update AndroidManifest.xml
Add permissions and service (see `FIREBASE_SETUP.md` for details)

### 6. iOS Configuration

#### 6.1 Download GoogleService-Info.plist
- [ ] In Firebase Console, add iOS app
- [ ] Enter bundle ID from Xcode project
- [ ] Download `GoogleService-Info.plist`
- [ ] Add to Xcode project (Runner folder)

#### 6.2 Enable Capabilities in Xcode
- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Select Runner target → Signing & Capabilities
- [ ] Add "Push Notifications" capability
- [ ] Add "Background Modes" capability
- [ ] Check "Remote notifications" in Background Modes

#### 6.3 Update AppDelegate.swift
Replace content with code from `FIREBASE_SETUP.md`

#### 6.4 Create and Upload APNs Key
- [ ] Create APNs key in Apple Developer Portal
- [ ] Download `.p8` file
- [ ] Upload to Firebase Console → Cloud Messaging → APNs Authentication Key

### 7. Update Code

In `lib/main.dart`, uncomment these lines in `_initializeFirebase()`:

```dart
// Uncomment these lines:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 8. Test the Implementation

```bash
flutter clean
flutter pub get
flutter run
```

Check for:
- [ ] "FCM Token: ..." in debug console
- [ ] "NotificationService initialized successfully" message
- [ ] No errors during initialization

### 9. Send Test Notification

- [ ] Copy FCM token from debug console
- [ ] Go to Firebase Console → Cloud Messaging
- [ ] Click "Send your first message"
- [ ] Send test notification to your token
- [ ] Verify notification is received

### 10. Backend Integration (Optional for now)

See `FIREBASE_BACKEND_INTEGRATION.md` for:
- [ ] Installing Firebase Admin SDK
- [ ] Creating notification service on backend
- [ ] Implementing token registration API
- [ ] Testing end-to-end notification flow

## Documentation Reference

| Document | Purpose |
|----------|---------|
| `FIREBASE_QUICKSTART.md` | 15-minute quick start guide |
| `FIREBASE_SETUP.md` | Comprehensive step-by-step setup |
| `FIREBASE_CHECKLIST.md` | Detailed checklist with all steps |
| `FIREBASE_BACKEND_INTEGRATION.md` | Backend integration guide |
| `FIREBASE_IMPLEMENTATION_SUMMARY.md` | What was implemented and why |
| `lib/core/services/README.md` | Service documentation |

## Quick Start Path

**For experienced developers** (15 minutes):
1. Follow `FIREBASE_QUICKSTART.md`

**For detailed guidance** (30 minutes):
1. Follow `FIREBASE_SETUP.md`
2. Use `FIREBASE_CHECKLIST.md` to track progress

## Common Issues

### "Firebase not initialized"
- Ensure `firebase_core` is added to `pubspec.yaml`
- Verify `flutterfire configure` was run successfully
- Check `lib/firebase_options.dart` exists

### "No FCM token"
- Check internet connection
- Verify Firebase is initialized before getting token
- Check Firebase config files are present

### Android build fails
- Verify `google-services.json` is in `android/app/`
- Check Google services plugin is applied in both gradle files
- Ensure package name matches in Firebase Console

### iOS notifications not working
- Verify APNs key is uploaded to Firebase Console
- Check Push Notifications capability is enabled
- Ensure `GoogleService-Info.plist` is in Xcode project

## Support

If you encounter issues:
1. Check the troubleshooting section in `FIREBASE_SETUP.md`
2. Review Firebase Console logs
3. Check Flutter debug console output
4. Consult the documentation files listed above

## Estimated Time

- **Firebase Console Setup**: 5 minutes
- **Android Configuration**: 10 minutes
- **iOS Configuration**: 15 minutes
- **Testing**: 5 minutes
- **Total**: ~35 minutes

## Next Steps After Setup

Once Firebase is configured and working:

1. **Implement Backend Integration**
   - Follow `FIREBASE_BACKEND_INTEGRATION.md`
   - Create API endpoints for token registration
   - Implement notification sending logic

2. **Add Deep Linking**
   - Handle notification tap events
   - Navigate to relevant screens based on notification data

3. **Create Notification Preferences UI**
   - Allow users to customize notification settings
   - Implement notification preferences API

4. **Add Analytics**
   - Track notification delivery rates
   - Monitor user engagement with notifications

---

**Status**: ⏳ Waiting for user to complete Firebase setup  
**Priority**: High  
**Blocking**: Backend notification integration
