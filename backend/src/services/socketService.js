const {
  getIO,
  socketAuthMiddleware,
  updateUserPresence,
  joinUserRoom,
  joinConversationRoom,
  leaveConversationRoom,
  joinRideRoom,
  leaveRideRoom,
} = require('../config/socket');

/**
 * Set up Socket.IO connection handlers and event listeners
 */
function setupSocketHandlers() {
  const io = getIO();

  // Apply authentication middleware
  io.use(socketAuthMiddleware);

  // Connection handler
  io.on('connection', (socket) => {
    console.log(`✅ Client connected: ${socket.id} (User: ${socket.userId})`);

    // Join user to their personal room
    joinUserRoom(socket);

    // Update user presence to online
    updateUserPresence(socket.userId, true);

    // Emit connection success
    socket.emit('connected', {
      message: 'Successfully connected to Socket.IO server',
      userId: socket.userId,
      socketId: socket.id,
    });

    // Handle ride room join
    socket.on('ride:join', (data) => {
      try {
        const { rideId } = data;
        if (!rideId) {
          socket.emit('error', { message: 'Ride ID is required' });
          return;
        }
        joinRideRoom(socket, rideId);
        socket.emit('ride:joined', { rideId });
      } catch (error) {
        console.error('Error joining ride room:', error);
        socket.emit('error', { message: 'Failed to join ride room' });
      }
    });

    // Handle ride room leave
    socket.on('ride:leave', (data) => {
      try {
        const { rideId } = data;
        if (!rideId) {
          socket.emit('error', { message: 'Ride ID is required' });
          return;
        }
        leaveRideRoom(socket, rideId);
        socket.emit('ride:left', { rideId });
      } catch (error) {
        console.error('Error leaving ride room:', error);
        socket.emit('error', { message: 'Failed to leave ride room' });
      }
    });

    // Handle conversation room join
    socket.on('conversation:join', (data) => {
      try {
        const { conversationId } = data;
        if (!conversationId) {
          socket.emit('error', { message: 'Conversation ID is required' });
          return;
        }
        joinConversationRoom(socket, conversationId);
        socket.emit('conversation:joined', { conversationId });
      } catch (error) {
        console.error('Error joining conversation room:', error);
        socket.emit('error', { message: 'Failed to join conversation room' });
      }
    });

    // Handle conversation room leave
    socket.on('conversation:leave', (data) => {
      try {
        const { conversationId } = data;
        if (!conversationId) {
          socket.emit('error', { message: 'Conversation ID is required' });
          return;
        }
        leaveConversationRoom(socket, conversationId);
        socket.emit('conversation:left', { conversationId });
      } catch (error) {
        console.error('Error leaving conversation room:', error);
        socket.emit('error', { message: 'Failed to leave conversation room' });
      }
    });

    // Handle typing start
    socket.on('typing:start', (data) => {
      try {
        const { conversationId } = data;
        if (!conversationId) {
          socket.emit('error', { message: 'Conversation ID is required' });
          return;
        }
        
        // Broadcast to conversation room except sender
        socket.to(`conversation:${conversationId}`).emit('typing:indicator', {
          conversationId,
          userId: socket.userId,
          isTyping: true,
        });
      } catch (error) {
        console.error('Error handling typing start:', error);
      }
    });

    // Handle typing stop
    socket.on('typing:stop', (data) => {
      try {
        const { conversationId } = data;
        if (!conversationId) {
          socket.emit('error', { message: 'Conversation ID is required' });
          return;
        }
        
        // Broadcast to conversation room except sender
        socket.to(`conversation:${conversationId}`).emit('typing:indicator', {
          conversationId,
          userId: socket.userId,
          isTyping: false,
        });
      } catch (error) {
        console.error('Error handling typing stop:', error);
      }
    });

    // Handle driver location update (for rides module)
    socket.on('driver:location_update', (data) => {
      try {
        const { rideId, lat, lng } = data;
        
        if (!rideId || lat === undefined || lng === undefined) {
          socket.emit('error', { message: 'Ride ID, latitude, and longitude are required' });
          return;
        }

        // Broadcast location to ride room
        socket.to(`ride:${rideId}`).emit('ride:location_update', {
          rideId,
          driverLocation: { lat, lng },
          timestamp: new Date().toISOString(),
        });
      } catch (error) {
        console.error('Error handling driver location update:', error);
        socket.emit('error', { message: 'Failed to update location' });
      }
    });

    // Handle disconnection
    socket.on('disconnect', (reason) => {
      console.log(`❌ Client disconnected: ${socket.id} (User: ${socket.userId}) - Reason: ${reason}`);
      
      // Update user presence to offline
      updateUserPresence(socket.userId, false);
    });

    // Handle errors
    socket.on('error', (error) => {
      console.error(`Socket error for ${socket.id}:`, error);
    });
  });

  console.log('✅ Socket.IO event handlers configured');
}

module.exports = {
  setupSocketHandlers,
};
