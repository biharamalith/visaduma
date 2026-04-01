const io = require('socket.io-client');
const jwt = require('jsonwebtoken');
require('dotenv').config();

/**
 * Test Socket.IO connection with JWT authentication
 */
async function testSocketConnection() {
  console.log('🧪 Testing Socket.IO connection...\n');

  // Generate a test JWT token
  const testUserId = 'test-user-123';
  const testRole = 'user';
  const token = jwt.sign(
    { id: testUserId, role: testRole },
    process.env.JWT_SECRET,
    { expiresIn: '15m' }
  );

  console.log('✅ Generated test JWT token');
  console.log(`   User ID: ${testUserId}`);
  console.log(`   Role: ${testRole}\n`);

  // Connect to Socket.IO server
  const socket = io(`http://localhost:${process.env.PORT || 3000}`, {
    auth: {
      token: token,
    },
    transports: ['websocket', 'polling'],
  });

  // Connection success
  socket.on('connect', () => {
    console.log('✅ Connected to Socket.IO server');
    console.log(`   Socket ID: ${socket.id}\n`);
  });

  // Connected event from server
  socket.on('connected', (data) => {
    console.log('✅ Received connection confirmation from server');
    console.log('   Data:', JSON.stringify(data, null, 2));
    console.log('');

    // Test joining a ride room
    console.log('🧪 Testing ride room join...');
    socket.emit('ride:join', { rideId: 'test-ride-123' });
  });

  // Ride joined confirmation
  socket.on('ride:joined', (data) => {
    console.log('✅ Successfully joined ride room');
    console.log('   Data:', JSON.stringify(data, null, 2));
    console.log('');

    // Test joining a conversation room
    console.log('🧪 Testing conversation room join...');
    socket.emit('conversation:join', { conversationId: 'test-conversation-456' });
  });

  // Conversation joined confirmation
  socket.on('conversation:joined', (data) => {
    console.log('✅ Successfully joined conversation room');
    console.log('   Data:', JSON.stringify(data, null, 2));
    console.log('');

    // Test typing indicator
    console.log('🧪 Testing typing indicator...');
    socket.emit('typing:start', { conversationId: 'test-conversation-456' });

    setTimeout(() => {
      socket.emit('typing:stop', { conversationId: 'test-conversation-456' });
      console.log('✅ Typing indicator test completed\n');

      // Test driver location update
      console.log('🧪 Testing driver location update...');
      socket.emit('driver:location_update', {
        rideId: 'test-ride-123',
        lat: 6.9271,
        lng: 79.8612,
      });
      console.log('✅ Driver location update sent\n');

      // Disconnect after tests
      setTimeout(() => {
        console.log('🧪 Disconnecting...');
        socket.disconnect();
      }, 1000);
    }, 1000);
  });

  // Error handling
  socket.on('error', (error) => {
    console.error('❌ Socket error:', error);
  });

  // Connection error
  socket.on('connect_error', (error) => {
    console.error('❌ Connection error:', error.message);
    process.exit(1);
  });

  // Disconnection
  socket.on('disconnect', (reason) => {
    console.log(`\n✅ Disconnected from Socket.IO server`);
    console.log(`   Reason: ${reason}`);
    console.log('\n✅ All Socket.IO tests completed successfully!');
    process.exit(0);
  });
}

// Run the test
console.log('='.repeat(60));
console.log('Socket.IO Connection Test');
console.log('='.repeat(60));
console.log('');

testSocketConnection().catch((error) => {
  console.error('❌ Test failed:', error);
  process.exit(1);
});
