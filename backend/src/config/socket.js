const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');
const { getRedisClient } = require('./redis');

let io = null;

/**
 * Initialize Socket.IO server with CORS configuration
 * @param {Object} httpServer - HTTP server instance
 * @returns {Server} Socket.IO server instance
 */
function initializeSocketIO(httpServer) {
  io = new Server(httpServer, {
    cors: {
      origin: process.env.CORS_ORIGIN || '*',
      methods: ['GET', 'POST'],
      credentials: true,
    },
    pingTimeout: 60000,
    pingInterval: 25000,
    transports: ['websocket', 'polling'],
  });

  console.log('✅ Socket.IO server initialized');
  return io;
}

/**
 * Get Socket.IO server instance
 * @returns {Server} Socket.IO server instance
 */
function getIO() {
  if (!io) {
    throw new Error('Socket.IO not initialized. Call initializeSocketIO first.');
  }
  return io;
}

/**
 * JWT authentication middleware for Socket.IO
 * Verifies JWT token from handshake auth or query
 */
function socketAuthMiddleware(socket, next) {
  try {
    // Extract token from auth or query parameters
    const token = socket.handshake.auth.token || socket.handshake.query.token;

    if (!token) {
      return next(new Error('Authentication error: Token missing'));
    }

    // Verify JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Attach user info to socket
    socket.userId = decoded.id;
    socket.userRole = decoded.role;
    
    next();
  } catch (error) {
    console.error('Socket authentication error:', error.message);
    return next(new Error('Authentication error: Invalid or expired token'));
  }
}

/**
 * Track user online status in Redis
 * @param {string} userId - User ID
 * @param {boolean} isOnline - Online status
 */
async function updateUserPresence(userId, isOnline) {
  try {
    const redis = getRedisClient();
    const key = `presence:${userId}`;
    
    if (isOnline) {
      await redis.setex(key, 300, 'online'); // 5 minutes TTL
    } else {
      await redis.del(key);
    }
  } catch (error) {
    console.error('Error updating user presence:', error);
  }
}

/**
 * Get user online status from Redis
 * @param {string} userId - User ID
 * @returns {Promise<boolean>} Online status
 */
async function getUserPresence(userId) {
  try {
    const redis = getRedisClient();
    const status = await redis.get(`presence:${userId}`);
    return status === 'online';
  } catch (error) {
    console.error('Error getting user presence:', error);
    return false;
  }
}

/**
 * Join user to their personal room
 * @param {Object} socket - Socket instance
 */
function joinUserRoom(socket) {
  const userRoom = `user:${socket.userId}`;
  socket.join(userRoom);
  console.log(`User ${socket.userId} joined room: ${userRoom}`);
}

/**
 * Join user to a conversation room
 * @param {Object} socket - Socket instance
 * @param {string} conversationId - Conversation ID
 */
function joinConversationRoom(socket, conversationId) {
  const conversationRoom = `conversation:${conversationId}`;
  socket.join(conversationRoom);
  console.log(`User ${socket.userId} joined conversation: ${conversationId}`);
}

/**
 * Leave a conversation room
 * @param {Object} socket - Socket instance
 * @param {string} conversationId - Conversation ID
 */
function leaveConversationRoom(socket, conversationId) {
  const conversationRoom = `conversation:${conversationId}`;
  socket.leave(conversationRoom);
  console.log(`User ${socket.userId} left conversation: ${conversationId}`);
}

/**
 * Join driver to a ride room
 * @param {Object} socket - Socket instance
 * @param {string} rideId - Ride ID
 */
function joinRideRoom(socket, rideId) {
  const rideRoom = `ride:${rideId}`;
  socket.join(rideRoom);
  console.log(`User ${socket.userId} joined ride: ${rideId}`);
}

/**
 * Leave a ride room
 * @param {Object} socket - Socket instance
 * @param {string} rideId - Ride ID
 */
function leaveRideRoom(socket, rideId) {
  const rideRoom = `ride:${rideId}`;
  socket.leave(rideRoom);
  console.log(`User ${socket.userId} left ride: ${rideId}`);
}

/**
 * Emit event to user's personal room
 * @param {string} userId - User ID
 * @param {string} event - Event name
 * @param {Object} data - Event data
 */
function emitToUser(userId, event, data) {
  if (!io) {
    console.error('Socket.IO not initialized');
    return;
  }
  
  const userRoom = `user:${userId}`;
  io.to(userRoom).emit(event, data);
}

/**
 * Emit event to conversation room
 * @param {string} conversationId - Conversation ID
 * @param {string} event - Event name
 * @param {Object} data - Event data
 */
function emitToConversation(conversationId, event, data) {
  if (!io) {
    console.error('Socket.IO not initialized');
    return;
  }
  
  const conversationRoom = `conversation:${conversationId}`;
  io.to(conversationRoom).emit(event, data);
}

/**
 * Emit event to ride room
 * @param {string} rideId - Ride ID
 * @param {string} event - Event name
 * @param {Object} data - Event data
 */
function emitToRide(rideId, event, data) {
  if (!io) {
    console.error('Socket.IO not initialized');
    return;
  }
  
  const rideRoom = `ride:${rideId}`;
  io.to(rideRoom).emit(event, data);
}

/**
 * Get all connected sockets for a user
 * @param {string} userId - User ID
 * @returns {Promise<Array>} Array of socket IDs
 */
async function getUserSockets(userId) {
  if (!io) {
    return [];
  }
  
  const userRoom = `user:${userId}`;
  const sockets = await io.in(userRoom).fetchSockets();
  return sockets.map(socket => socket.id);
}

module.exports = {
  initializeSocketIO,
  getIO,
  socketAuthMiddleware,
  updateUserPresence,
  getUserPresence,
  joinUserRoom,
  joinConversationRoom,
  leaveConversationRoom,
  joinRideRoom,
  leaveRideRoom,
  emitToUser,
  emitToConversation,
  emitToRide,
  getUserSockets,
};
