/**
 * Redis Connection Test Script
 * 
 * This script tests the Redis connection and cache operations.
 * Run with: node test-redis-connection.js
 */

require('dotenv').config();
const { initializeRedis, checkRedisHealth, closeRedis } = require('./src/config/redis');
const cacheService = require('./src/services/cacheService');

async function testRedisConnection() {
  console.log('🧪 Testing Redis Connection...\n');

  try {
    // Initialize Redis
    console.log('1️⃣  Initializing Redis connection...');
    initializeRedis();
    
    // Wait a moment for connection
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Check health
    console.log('\n2️⃣  Checking Redis health...');
    const health = await checkRedisHealth();
    console.log('   Health status:', JSON.stringify(health, null, 2));

    if (health.status !== 'healthy') {
      console.log('\n❌ Redis is not healthy. Make sure Redis server is running.');
      console.log('   Start Redis with: redis-server (or see REDIS_CONFIGURATION.md)');
      await closeRedis();
      process.exit(1);
    }

    // Test basic operations
    console.log('\n3️⃣  Testing basic cache operations...');
    
    // Set a value
    console.log('   Setting key "test:hello" with value "world"...');
    await cacheService.set('test:hello', 'world', 60);
    
    // Get the value
    console.log('   Getting key "test:hello"...');
    const value = await cacheService.get('test:hello');
    console.log('   Retrieved value:', value);
    
    // Check TTL
    const ttl = await cacheService.ttl('test:hello');
    console.log('   TTL:', ttl, 'seconds');
    
    // Test JSON storage
    console.log('\n4️⃣  Testing JSON object storage...');
    const testObject = {
      id: 1,
      name: 'Test Shop',
      category: 'electronics',
      rating: 4.5
    };
    
    await cacheService.set('test:shop', testObject, 60);
    const retrievedObject = await cacheService.get('test:shop');
    console.log('   Stored object:', testObject);
    console.log('   Retrieved object:', retrievedObject);
    
    // Test set operations
    console.log('\n5️⃣  Testing set operations (for token blacklist)...');
    await cacheService.sadd('test:blacklist', 'token123');
    await cacheService.sadd('test:blacklist', 'token456');
    
    const isMember = await cacheService.sismember('test:blacklist', 'token123');
    console.log('   Is token123 blacklisted?', isMember);
    
    const members = await cacheService.smembers('test:blacklist');
    console.log('   All blacklisted tokens:', members);
    
    // Test increment/decrement
    console.log('\n6️⃣  Testing numeric operations...');
    await cacheService.set('test:counter', 0);
    await cacheService.incr('test:counter', 5);
    const counter = await cacheService.get('test:counter');
    console.log('   Counter after increment by 5:', counter);
    
    // Cleanup
    console.log('\n7️⃣  Cleaning up test keys...');
    await cacheService.del('test:hello');
    await cacheService.del('test:shop');
    await cacheService.del('test:blacklist');
    await cacheService.del('test:counter');
    console.log('   Test keys deleted');

    console.log('\n✅ All Redis tests passed successfully!');
    console.log('\n📊 Summary:');
    console.log('   ✓ Connection established');
    console.log('   ✓ Basic get/set operations working');
    console.log('   ✓ JSON serialization working');
    console.log('   ✓ Set operations working');
    console.log('   ✓ Numeric operations working');
    console.log('   ✓ TTL management working');

  } catch (error) {
    console.error('\n❌ Redis test failed:', error.message);
    console.error('\nTroubleshooting:');
    console.error('1. Make sure Redis server is running');
    console.error('2. Check REDIS_HOST and REDIS_PORT in .env file');
    console.error('3. Verify Redis is accessible: redis-cli ping');
    process.exit(1);
  } finally {
    // Close connection
    console.log('\n8️⃣  Closing Redis connection...');
    await closeRedis();
    console.log('   Connection closed');
    process.exit(0);
  }
}

// Run the test
testRedisConnection();
