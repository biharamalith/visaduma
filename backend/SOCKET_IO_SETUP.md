# Socket.IO Setup Documentation

## Overview

This document describes the Socket.IO real-time communication setup for the VisaDuma backend. Socket.IO enables bidirectional, event-based communication between clients and the server for features like:

- **Rides Module**: Real-time driver location tracking, ride status updates
- **Chat Module**: Real-time messaging, typing indicators, presence status
- **Notifications**: Real-time push notifications to connected clients

## Architecture

### Components

1. **Socket.IO Server** (`src/config/socket.js`)
   - Initializes Socket.IO with CORS configuration
   - Provides utility functions for room management
   - Handles user presence tracking in Redis

2. **Authentication Middleware** (`src/config/socket.js`)
   - Validates JWT tokens on connection
   - Extracts user ID and role from token
   - Rejects unauthorized connections

3. **Event Handlers** (`src/services/socketService.js`)
   - Connection/disconnection handlers
   - Room join/leave handlers
   - Real-time event handlers (typing, location updates)

4. **Server Integration** (`src/server.js`)
   - Creates HTTP server with Express
   - Initializes Socket.IO on HTTP server
   - Sets up event handlers

## Authentication

### JWT Token Authentication

Socket.IO connections are authenticated using JWT tokens. Clients must provide a valid JWT token when connecting.

**Client Connection Example:**

```javascript
import io from 'socket.io-client';

const socket = io('http://localhost:3000', {
  auth: {
    token: 'your-jwt-token-here'
  }
});
```

**Alternative (Query Parameter):**

```javascript
const socket = io('http://localhost:3000', {
  query: {
    token: 'your-jwt-token-here'
  }
});
```

### Authentication Flow

1. Client connects with JWT token in `auth` or `query`
2. Server validates token using `socketAuthMiddleware`
3. If valid, user ID and role are attached to socket
4. If invalid, connection is rejected with error

## Room Management

### Room Types

1. **User Rooms** (`user:{userId}`)
   - Personal room for each user
   - Automatically joined on connection
   - Used for user-specific notifications

2. **Ride Rooms** (`ride:{rideId}`)
   - Room for a specific ride
   - Both user and driver join this room
   - Used for location updates and ride status

3. **Conversation Rooms** (`conversation:{conversationId}`)
   - Room for a specific chat conversation
   - Both participants join this room
   - Used for messages and typing indicators

### Joining Rooms

**User Room (Automatic):**
```javascript
// Automatically joined on connection
// No client action needed
```

**Ride Room:**
```javascript
// Client emits
socket.emit('ride:join', { rideId: 'ride-123' });

// Server confirms
socket.on('ride:joined', (data) => {
  console.log('Joined ride:', data.rideId);
});
```

**Conversation Room:**
```javascript
// Client emits
socket.emit('conversation:join', { conversationId: 'conv-456' });

// Server confirms
socket.on('conversation:joined', (data) => {
  console.log('Joined conversation:', data.conversationId);
});
```

### Leaving Rooms

**Ride Room:**
```javascript
socket.emit('ride:leave', { rideId: 'ride-123' });

socket.on('ride:left', (data) => {
  console.log('Left ride:', data.rideId);
});
```

**Conversation Room:**
```javascript
socket.emit('conversation:leave', { conversationId: 'conv-456' });

socket.on('conversation:left', (data) => {
  console.log('Left conversation:', data.conversationId);
});
```

## Events

### Connection Events

**Connected:**
```javascript
socket.on('connected', (data) => {
  // { message, userId, socketId }
  console.log('Connected:', data);
});
```

**Disconnected:**
```javascript
socket.on('disconnect', (reason) => {
  console.log('Disconnected:', reason);
});
```

**Error:**
```javascript
socket.on('error', (error) => {
  console.error('Socket error:', error);
});
```

### Ride Events

**Driver Location Update (Driver → Server):**
```javascript
socket.emit('driver:location_update', {
  rideId: 'ride-123',
  lat: 6.9271,
  lng: 79.8612
});
```

**Location Update (Server → User):**
```javascript
socket.on('ride:location_update', (data) => {
  // { rideId, driverLocation: { lat, lng }, timestamp }
  console.log('Driver location:', data.driverLocation);
});
```

**Ride Status Update (Server → Client):**
```javascript
socket.on('ride:status_changed', (data) => {
  // { rideId, status, timestamp }
  console.log('Ride status:', data.status);
});
```

**Driver Assigned (Server → User):**
```javascript
socket.on('ride:driver_assigned', (data) => {
  // { rideId, driver: { id, name, phone, vehicle } }
  console.log('Driver assigned:', data.driver);
});
```

### Chat Events

**Typing Start:**
```javascript
socket.emit('typing:start', { conversationId: 'conv-456' });
```

**Typing Stop:**
```javascript
socket.emit('typing:stop', { conversationId: 'conv-456' });
```

**Typing Indicator (Server → Client):**
```javascript
socket.on('typing:indicator', (data) => {
  // { conversationId, userId, isTyping }
  if (data.isTyping) {
    console.log('User is typing...');
  } else {
    console.log('User stopped typing');
  }
});
```

**Message Received (Server → Client):**
```javascript
socket.on('message:received', (data) => {
  // { messageId, conversationId, senderId, content, timestamp }
  console.log('New message:', data.content);
});
```

**Message Sent Confirmation (Server → Sender):**
```javascript
socket.on('message:sent', (data) => {
  // { messageId, timestamp }
  console.log('Message sent:', data.messageId);
});
```

## Server-Side Utilities

### Emitting to Specific Users/Rooms

**Emit to User:**
```javascript
const { emitToUser } = require('./config/socket');

emitToUser('user-123', 'notification:new', {
  title: 'New Order',
  body: 'Your order has been confirmed'
});
```

**Emit to Ride:**
```javascript
const { emitToRide } = require('./config/socket');

emitToRide('ride-123', 'ride:status_changed', {
  rideId: 'ride-123',
  status: 'in_progress',
  timestamp: new Date().toISOString()
});
```

**Emit to Conversation:**
```javascript
const { emitToConversation } = require('./config/socket');

emitToConversation('conv-456', 'message:received', {
  messageId: 'msg-789',
  senderId: 'user-123',
  content: 'Hello!',
  timestamp: new Date().toISOString()
});
```

### Presence Management

**Update User Presence:**
```javascript
const { updateUserPresence } = require('./config/socket');

// Set user online
await updateUserPresence('user-123', true);

// Set user offline
await updateUserPresence('user-123', false);
```

**Check User Presence:**
```javascript
const { getUserPresence } = require('./config/socket');

const isOnline = await getUserPresence('user-123');
console.log('User online:', isOnline);
```

## Configuration

### Environment Variables

Add to `.env`:

```env
# CORS Configuration for Socket.IO
CORS_ORIGIN=*

# JWT Configuration (already exists)
JWT_SECRET=your_secret_key
JWT_EXPIRES_IN=15m
```

### CORS Configuration

The Socket.IO server is configured with CORS to allow connections from any origin in development. For production, update `CORS_ORIGIN` to your frontend domain:

```env
CORS_ORIGIN=https://yourdomain.com
```

## Testing

### Running the Test

1. Start the server:
   ```bash
   npm run dev
   ```

2. In another terminal, run the Socket.IO test:
   ```bash
   npm run test:socket
   ```

### Expected Output

```
============================================================
Socket.IO Connection Test
============================================================

🧪 Testing Socket.IO connection...

✅ Generated test JWT token
   User ID: test-user-123
   Role: user

✅ Connected to Socket.IO server
   Socket ID: abc123

✅ Received connection confirmation from server
   Data: {
     "message": "Successfully connected to Socket.IO server",
     "userId": "test-user-123",
     "socketId": "abc123"
   }

🧪 Testing ride room join...
✅ Successfully joined ride room
   Data: { "rideId": "test-ride-123" }

🧪 Testing conversation room join...
✅ Successfully joined conversation room
   Data: { "conversationId": "test-conversation-456" }

🧪 Testing typing indicator...
✅ Typing indicator test completed

🧪 Testing driver location update...
✅ Driver location update sent

🧪 Disconnecting...

✅ Disconnected from Socket.IO server
   Reason: client namespace disconnect

✅ All Socket.IO tests completed successfully!
```

## Error Handling

### Common Errors

**Authentication Error:**
```javascript
socket.on('connect_error', (error) => {
  // Error: "Authentication error: Token missing"
  // Error: "Authentication error: Invalid or expired token"
});
```

**Missing Parameters:**
```javascript
socket.on('error', (error) => {
  // Error: { message: "Ride ID is required" }
  // Error: { message: "Conversation ID is required" }
});
```

### Error Handling Best Practices

1. Always handle `connect_error` event
2. Always handle `error` event
3. Implement reconnection logic on client
4. Validate all event data on server
5. Log errors for debugging

## Performance Considerations

### Connection Pooling

Socket.IO automatically manages connection pooling. Configure limits in production:

```javascript
const io = new Server(httpServer, {
  maxHttpBufferSize: 1e6, // 1MB
  pingTimeout: 60000,
  pingInterval: 25000,
});
```

### Location Update Throttling

For ride tracking, throttle location updates to avoid overwhelming the server:

```javascript
// Client-side throttling
let lastUpdate = 0;
const THROTTLE_MS = 5000; // 5 seconds

function updateLocation(lat, lng) {
  const now = Date.now();
  if (now - lastUpdate < THROTTLE_MS) return;
  
  socket.emit('driver:location_update', { rideId, lat, lng });
  lastUpdate = now;
}
```

### Redis Presence TTL

User presence is stored in Redis with 5-minute TTL. This automatically cleans up stale presence data.

## Security Best Practices

1. **Always use JWT authentication** - Never allow unauthenticated connections
2. **Validate all event data** - Check for required fields and data types
3. **Use WSS in production** - Enable SSL/TLS for WebSocket connections
4. **Rate limit events** - Prevent abuse by limiting event frequency
5. **Sanitize user input** - Never trust client data
6. **Use room-based authorization** - Verify users can access rooms they join

## Integration with Other Modules

### Rides Module

When a ride is created or updated, emit events to the ride room:

```javascript
const { emitToRide } = require('../config/socket');

// After driver accepts ride
emitToRide(rideId, 'ride:driver_assigned', {
  rideId,
  driver: { id, name, phone, vehicle }
});

// After ride status changes
emitToRide(rideId, 'ride:status_changed', {
  rideId,
  status: 'in_progress'
});
```

### Chat Module

When a message is sent, emit to the conversation room:

```javascript
const { emitToConversation } = require('../config/socket');

// After message is saved to database
emitToConversation(conversationId, 'message:received', {
  messageId,
  conversationId,
  senderId,
  content,
  timestamp
});
```

### Notifications Module

When a notification is created, emit to the user's personal room:

```javascript
const { emitToUser } = require('../config/socket');

// After notification is created
emitToUser(userId, 'notification:new', {
  notificationId,
  title,
  body,
  type,
  timestamp
});
```

## Next Steps

1. ✅ Socket.IO server setup complete
2. ⏳ Implement Rides module with real-time tracking
3. ⏳ Implement Chat module with real-time messaging
4. ⏳ Implement Notifications module with real-time push
5. ⏳ Add comprehensive error handling and logging
6. ⏳ Implement rate limiting for events
7. ⏳ Add monitoring and analytics

## Troubleshooting

### Server won't start

- Check if port 3000 is already in use
- Verify Redis is running (`npm run test:redis`)
- Check environment variables in `.env`

### Client can't connect

- Verify JWT token is valid
- Check CORS configuration
- Ensure server is running
- Check network/firewall settings

### Events not received

- Verify client joined the correct room
- Check server logs for errors
- Ensure event names match exactly
- Verify user has permission to access room

## Resources

- [Socket.IO Documentation](https://socket.io/docs/v4/)
- [Socket.IO Client API](https://socket.io/docs/v4/client-api/)
- [Socket.IO Server API](https://socket.io/docs/v4/server-api/)
- [JWT Authentication](https://jwt.io/)
