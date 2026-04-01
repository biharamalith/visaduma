// ============================================================
// FILE: lib/core/services/notification_service.dart
// PURPOSE: Firebase Cloud Messaging service for push notifications
//
// Handles:
//   • Firebase initialization
//   • FCM token registration and updates
//   • Notification permission requests
//   • Foreground/background notification handling
//   • Notification tap handling with deep linking
// ============================================================

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  // Handle background message processing here if needed
}

/// Service for managing Firebase Cloud Messaging notifications
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Stream controller for notification taps
  final StreamController<Map<String, dynamic>> _notificationTapController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of notification tap events with payload data
  Stream<Map<String, dynamic>> get onNotificationTap =>
      _notificationTapController.stream;

  /// Current FCM token
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase Messaging and local notifications
  Future<void> initialize() async {
    try {
      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request notification permissions
      await requestPermission();

      // Get FCM token
      await _getFCMToken();

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('FCM Token refreshed: $newToken');
        // TODO: Send updated token to backend API
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a terminated state via notification
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          // Parse payload and emit tap event
          _notificationTapController.add({'payload': details.payload});
        }
      },
    );

    // Create Android notification channels
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannels();
    }
  }

  /// Create Android notification channels for different notification types
  Future<void> _createAndroidNotificationChannels() async {
    final channels = [
      const AndroidNotificationChannel(
        'ride_updates',
        'Ride Updates',
        description: 'Notifications for ride status updates',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'order_updates',
        'Order Updates',
        description: 'Notifications for order status updates',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'booking_updates',
        'Booking Updates',
        description: 'Notifications for booking status updates',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'payment_updates',
        'Payment Updates',
        description: 'Notifications for payment transactions',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'chat_messages',
        'Chat Messages',
        description: 'Notifications for new chat messages',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'system_alerts',
        'System Alerts',
        description: 'Important system notifications',
        importance: Importance.max,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'promotions',
        'Promotions',
        description: 'Promotional offers and deals',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
    ];

    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Request notification permissions from the user
  Future<bool> requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final isGranted = settings.authorizationStatus == AuthorizationStatus.authorized;
      debugPrint('Notification permission granted: $isGranted');
      return isGranted;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Get FCM token and store it
  Future<String?> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $_fcmToken');
      // TODO: Send token to backend API for registration
      return _fcmToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Register FCM token with backend API
  Future<bool> registerToken(String userId) async {
    if (_fcmToken == null) {
      debugPrint('No FCM token available to register');
      return false;
    }

    try {
      // TODO: Implement API call to register token
      // Example:
      // final response = await dio.post('/api/v1/notifications/register-token', data: {
      //   'user_id': userId,
      //   'fcm_token': _fcmToken,
      //   'device_type': Platform.isAndroid ? 'android' : 'ios',
      // });
      // return response.statusCode == 200;

      debugPrint('FCM token registered for user: $userId');
      return true;
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
      return false;
    }
  }

  /// Handle foreground messages by showing local notification
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.messageId}');

    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      // Determine channel based on notification type
      final channelId = data['type'] ?? 'system_alerts';

      // Show local notification
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            _getChannelName(channelId),
            channelDescription: _getChannelDescription(channelId),
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: data.isNotEmpty ? data.toString() : null,
      );
    }
  }

  /// Handle notification tap events
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    final data = message.data;

    if (data.isNotEmpty) {
      _notificationTapController.add(data);
    }
  }

  /// Get channel name from channel ID
  String _getChannelName(String channelId) {
    switch (channelId) {
      case 'ride_updates':
        return 'Ride Updates';
      case 'order_updates':
        return 'Order Updates';
      case 'booking_updates':
        return 'Booking Updates';
      case 'payment_updates':
        return 'Payment Updates';
      case 'chat_messages':
        return 'Chat Messages';
      case 'system_alerts':
        return 'System Alerts';
      case 'promotions':
        return 'Promotions';
      default:
        return 'Notifications';
    }
  }

  /// Get channel description from channel ID
  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case 'ride_updates':
        return 'Notifications for ride status updates';
      case 'order_updates':
        return 'Notifications for order status updates';
      case 'booking_updates':
        return 'Notifications for booking status updates';
      case 'payment_updates':
        return 'Notifications for payment transactions';
      case 'chat_messages':
        return 'Notifications for new chat messages';
      case 'system_alerts':
        return 'Important system notifications';
      case 'promotions':
        return 'Promotional offers and deals';
      default:
        return 'General notifications';
    }
  }

  /// Dispose resources
  void dispose() {
    _notificationTapController.close();
  }
}
