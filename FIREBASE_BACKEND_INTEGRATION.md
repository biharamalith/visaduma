# Firebase Backend Integration Guide

This guide explains how to integrate Firebase Cloud Messaging with the VisaDuma backend for sending push notifications.

## Overview

The notification flow:
1. **App** → Obtains FCM token from Firebase
2. **App** → Sends FCM token to backend API
3. **Backend** → Stores FCM token in database
4. **Backend** → Sends notifications via Firebase Admin SDK
5. **Firebase** → Delivers notification to device
6. **App** → Displays notification and handles tap

## Backend Setup

### 1. Install Firebase Admin SDK

```bash
cd backend
npm install firebase-admin
```

### 2. Download Service Account Key

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Save the JSON file as `firebase-service-account.json`
4. **IMPORTANT**: Add to `.gitignore` and never commit this file!

### 3. Initialize Firebase Admin

Create `backend/src/config/firebase.js`:

```javascript
const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
const serviceAccount = require(path.join(__dirname, '../../firebase-service-account.json'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: process.env.FIREBASE_PROJECT_ID,
});

const messaging = admin.messaging();

module.exports = { admin, messaging };
```

### 4. Add to Environment Variables

Add to `backend/.env`:

```env
FIREBASE_PROJECT_ID=your-project-id
```

## Database Schema

### FCM Tokens Table

```sql
CREATE TABLE fcm_tokens (
  id              INT PRIMARY KEY AUTO_INCREMENT,
  user_id         VARCHAR(36) NOT NULL,
  fcm_token       VARCHAR(512) NOT NULL UNIQUE,
  device_type     ENUM('android', 'ios', 'web') NOT NULL,
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_fcm_token (fcm_token),
  INDEX idx_active (is_active)
);
```

## API Endpoints

### Register FCM Token

**Endpoint**: `POST /api/v1/notifications/register-token`

**Request**:
```json
{
  "fcm_token": "fcm-token-string",
  "device_type": "android"
}
```

**Implementation** (`backend/src/routes/notifications.js`):

```javascript
const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');
const db = require('../config/database');

// Register or update FCM token
router.post('/register-token', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { fcm_token, device_type } = req.body;

    // Validate input
    if (!fcm_token || !device_type) {
      return res.status(400).json({
        success: false,
        message: 'FCM token and device type are required',
      });
    }

    // Check if token already exists
    const [existing] = await db.execute(
      'SELECT id, user_id FROM fcm_tokens WHERE fcm_token = ?',
      [fcm_token]
    );

    if (existing.length > 0) {
      // Update existing token
      await db.execute(
        'UPDATE fcm_tokens SET user_id = ?, device_type = ?, is_active = 1, updated_at = NOW() WHERE fcm_token = ?',
        [userId, device_type, fcm_token]
      );
    } else {
      // Insert new token
      await db.execute(
        'INSERT INTO fcm_tokens (user_id, fcm_token, device_type) VALUES (?, ?, ?)',
        [userId, fcm_token, device_type]
      );
    }

    res.json({
      success: true,
      message: 'FCM token registered successfully',
    });
  } catch (error) {
    console.error('Error registering FCM token:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to register FCM token',
    });
  }
});

module.exports = router;
```

### Deactivate FCM Token

**Endpoint**: `POST /api/v1/notifications/deactivate-token`

**Request**:
```json
{
  "fcm_token": "fcm-token-string"
}
```

**Implementation**:

```javascript
router.post('/deactivate-token', authenticateToken, async (req, res) => {
  try {
    const { fcm_token } = req.body;

    await db.execute(
      'UPDATE fcm_tokens SET is_active = 0 WHERE fcm_token = ?',
      [fcm_token]
    );

    res.json({
      success: true,
      message: 'FCM token deactivated',
    });
  } catch (error) {
    console.error('Error deactivating FCM token:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to deactivate FCM token',
    });
  }
});
```

## Notification Service

Create `backend/src/services/notificationService.js`:

```javascript
const { messaging } = require('../config/firebase');
const db = require('../config/database');

class NotificationService {
  /**
   * Send notification to a single user
   */
  async sendToUser(userId, notification, data = {}) {
    try {
      // Get active FCM tokens for user
      const [tokens] = await db.execute(
        'SELECT fcm_token, device_type FROM fcm_tokens WHERE user_id = ? AND is_active = 1',
        [userId]
      );

      if (tokens.length === 0) {
        console.log(`No active FCM tokens for user ${userId}`);
        return { success: false, message: 'No active tokens' };
      }

      // Send to all user's devices
      const results = await Promise.allSettled(
        tokens.map(token => this.sendToToken(token.fcm_token, notification, data))
      );

      // Deactivate failed tokens
      const failedTokens = results
        .map((result, index) => result.status === 'rejected' ? tokens[index].fcm_token : null)
        .filter(token => token !== null);

      if (failedTokens.length > 0) {
        await this.deactivateTokens(failedTokens);
      }

      return {
        success: true,
        sent: results.filter(r => r.status === 'fulfilled').length,
        failed: failedTokens.length,
      };
    } catch (error) {
      console.error('Error sending notification to user:', error);
      throw error;
    }
  }

  /**
   * Send notification to a specific FCM token
   */
  async sendToToken(fcmToken, notification, data = {}) {
    try {
      const message = {
        token: fcmToken,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: {
          ...data,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        android: {
          priority: 'high',
          notification: {
            channelId: data.type || 'system_alerts',
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              badge: notification.badge || 1,
              sound: 'default',
              contentAvailable: true,
            },
          },
        },
      };

      const response = await messaging.send(message);
      console.log('Notification sent successfully:', response);
      return response;
    } catch (error) {
      console.error('Error sending notification:', error);
      throw error;
    }
  }

  /**
   * Send notification to multiple users
   */
  async sendToMultipleUsers(userIds, notification, data = {}) {
    const results = await Promise.allSettled(
      userIds.map(userId => this.sendToUser(userId, notification, data))
    );

    return {
      success: true,
      results: results.map((result, index) => ({
        userId: userIds[index],
        status: result.status,
        data: result.status === 'fulfilled' ? result.value : result.reason,
      })),
    };
  }

  /**
   * Send notification using multicast (up to 500 tokens)
   */
  async sendMulticast(fcmTokens, notification, data = {}) {
    try {
      const message = {
        tokens: fcmTokens,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: {
          ...data,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        android: {
          priority: 'high',
          notification: {
            channelId: data.type || 'system_alerts',
          },
        },
        apns: {
          payload: {
            aps: {
              badge: notification.badge || 1,
              sound: 'default',
            },
          },
        },
      };

      const response = await messaging.sendEachForMulticast(message);
      
      // Deactivate failed tokens
      const failedTokens = response.responses
        .map((resp, index) => !resp.success ? fcmTokens[index] : null)
        .filter(token => token !== null);

      if (failedTokens.length > 0) {
        await this.deactivateTokens(failedTokens);
      }

      return {
        success: true,
        successCount: response.successCount,
        failureCount: response.failureCount,
      };
    } catch (error) {
      console.error('Error sending multicast notification:', error);
      throw error;
    }
  }

  /**
   * Deactivate invalid FCM tokens
   */
  async deactivateTokens(fcmTokens) {
    try {
      const placeholders = fcmTokens.map(() => '?').join(',');
      await db.execute(
        `UPDATE fcm_tokens SET is_active = 0 WHERE fcm_token IN (${placeholders})`,
        fcmTokens
      );
      console.log(`Deactivated ${fcmTokens.length} invalid tokens`);
    } catch (error) {
      console.error('Error deactivating tokens:', error);
    }
  }

  /**
   * Save notification to database for in-app notification center
   */
  async saveNotification(userId, notification, data = {}) {
    try {
      await db.execute(
        `INSERT INTO notifications (user_id, type, title, body, data, reference_type, reference_id)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [
          userId,
          data.type || 'system',
          notification.title,
          notification.body,
          JSON.stringify(data),
          data.reference_type || null,
          data.reference_id || null,
        ]
      );
    } catch (error) {
      console.error('Error saving notification:', error);
    }
  }
}

module.exports = new NotificationService();
```

## Usage Examples

### Ride Notifications

```javascript
const notificationService = require('../services/notificationService');

// When driver is assigned
async function notifyDriverAssigned(rideId, userId, driverName) {
  const notification = {
    title: 'Driver Assigned',
    body: `${driverName} is on the way to pick you up!`,
  };

  const data = {
    type: 'ride_updates',
    reference_type: 'ride',
    reference_id: rideId,
  };

  await notificationService.sendToUser(userId, notification, data);
  await notificationService.saveNotification(userId, notification, data);
}

// When ride is completed
async function notifyRideCompleted(rideId, userId, fare) {
  const notification = {
    title: 'Ride Completed',
    body: `Your ride has been completed. Fare: LKR ${fare}`,
  };

  const data = {
    type: 'ride_updates',
    reference_type: 'ride',
    reference_id: rideId,
  };

  await notificationService.sendToUser(userId, notification, data);
  await notificationService.saveNotification(userId, notification, data);
}
```

### Order Notifications

```javascript
// When order is confirmed
async function notifyOrderConfirmed(orderId, userId, orderNumber) {
  const notification = {
    title: 'Order Confirmed',
    body: `Your order #${orderNumber} has been confirmed!`,
  };

  const data = {
    type: 'order_updates',
    reference_type: 'order',
    reference_id: orderId,
  };

  await notificationService.sendToUser(userId, notification, data);
  await notificationService.saveNotification(userId, notification, data);
}
```

### Payment Notifications

```javascript
// When payment succeeds
async function notifyPaymentSuccess(userId, amount, transactionId) {
  const notification = {
    title: 'Payment Successful',
    body: `Your payment of LKR ${amount} was successful`,
  };

  const data = {
    type: 'payment_updates',
    reference_type: 'transaction',
    reference_id: transactionId,
  };

  await notificationService.sendToUser(userId, notification, data);
  await notificationService.saveNotification(userId, notification, data);
}
```

## Flutter Integration

Update `lib/core/services/notification_service.dart` to call the backend API:

```dart
/// Register FCM token with backend API
Future<bool> registerToken(String userId) async {
  if (_fcmToken == null) {
    debugPrint('No FCM token available to register');
    return false;
  }

  try {
    final dio = Dio(); // Use your configured Dio instance
    final response = await dio.post(
      '/api/v1/notifications/register-token',
      data: {
        'fcm_token': _fcmToken,
        'device_type': Platform.isAndroid ? 'android' : 'ios',
      },
    );

    if (response.statusCode == 200) {
      debugPrint('FCM token registered successfully');
      return true;
    }
    return false;
  } catch (e) {
    debugPrint('Error registering FCM token: $e');
    return false;
  }
}
```

## Testing

### Test Notification Sending

Create `backend/test-notification.js`:

```javascript
const notificationService = require('./src/services/notificationService');

async function testNotification() {
  const userId = 'your-test-user-id';
  
  const notification = {
    title: 'Test Notification',
    body: 'This is a test notification from the backend',
  };

  const data = {
    type: 'system_alerts',
    reference_type: 'test',
    reference_id: 'test-123',
  };

  const result = await notificationService.sendToUser(userId, notification, data);
  console.log('Result:', result);
}

testNotification();
```

Run:
```bash
node backend/test-notification.js
```

## Best Practices

1. **Error Handling**: Always handle FCM errors gracefully
2. **Token Management**: Deactivate invalid tokens automatically
3. **Rate Limiting**: Implement rate limiting to prevent spam
4. **Batching**: Use multicast for sending to multiple users
5. **Persistence**: Save notifications to database for in-app display
6. **User Preferences**: Respect user notification preferences
7. **Localization**: Send notifications in user's preferred language
8. **Analytics**: Track notification delivery and engagement

## Security Considerations

1. **Never expose service account key** in client code or public repositories
2. **Validate user permissions** before sending notifications
3. **Sanitize notification content** to prevent XSS
4. **Rate limit** notification sending per user
5. **Implement token rotation** for security
6. **Use HTTPS** for all API calls
7. **Validate FCM tokens** before storing

## Monitoring

Track these metrics:
- Notification delivery rate
- Failed token count
- User engagement (tap rate)
- Notification preferences changes
- API response times

## Resources

- [Firebase Admin SDK Documentation](https://firebase.google.com/docs/admin/setup)
- [FCM Server Documentation](https://firebase.google.com/docs/cloud-messaging/server)
- [FCM HTTP v1 API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)
