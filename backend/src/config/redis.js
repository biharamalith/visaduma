const Redis = require('ioredis');

/**
 * Redis Client Configuration and Connection Management
 * Provides caching and session management for the VisaDuma platform
 * 
 * Features:
 * - Automatic reconnection with exponential backoff
 * - Connection health monitoring
 * - Error handling and logging
 * - Support for both development and production environments
 */

let redisClient = null;

/**
 * Initialize Redis connection
 * @returns {Redis} Redis client instance
 */
function initializeRedis() {
  if (redisClient) {
    return redisClient;
  }

  const redisConfig = {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT) || 6379,
    password: process.env.REDIS_PASSWORD || undefined,
    retryStrategy: (times) => {
      // Exponential backoff: 50ms, 100ms, 200ms, 400ms, 800ms, max 2000ms
      const delay = Math.min(times * 50, 2000);
      console.log(`⏳ Redis reconnection attempt ${times}, waiting ${delay}ms...`);
      return delay;
    },
    maxRetriesPerRequest: 3,
    enableReadyCheck: true,
    lazyConnect: false,
  };

  redisClient = new Redis(redisConfig);

  // Connection event handlers
  redisClient.on('connect', () => {
    console.log('🔌 Redis client connecting...');
  });

  redisClient.on('ready', () => {
    console.log('✅ Redis client connected and ready');
  });

  redisClient.on('error', (err) => {
    console.error('❌ Redis client error:', err.message);
  });

  redisClient.on('close', () => {
    console.log('🔌 Redis connection closed');
  });

  redisClient.on('reconnecting', () => {
    console.log('🔄 Redis client reconnecting...');
  });

  return redisClient;
}

/**
 * Get Redis client instance
 * @returns {Redis|null} Redis client or null if not initialized
 */
function getRedisClient() {
  if (!redisClient) {
    console.warn('⚠️  Redis client not initialized. Call initializeRedis() first.');
    return null;
  }
  return redisClient;
}

/**
 * Check Redis connection health
 * @returns {Promise<Object>} Health status object
 */
async function checkRedisHealth() {
  try {
    if (!redisClient) {
      return {
        status: 'not_initialized',
        message: 'Redis client not initialized',
        timestamp: new Date().toISOString(),
      };
    }

    const start = Date.now();
    await redisClient.ping();
    const latency = Date.now() - start;

    return {
      status: 'healthy',
      latency: `${latency}ms`,
      timestamp: new Date().toISOString(),
    };
  } catch (err) {
    return {
      status: 'unhealthy',
      error: err.message,
      timestamp: new Date().toISOString(),
    };
  }
}

/**
 * Gracefully close Redis connection
 * @returns {Promise<void>}
 */
async function closeRedis() {
  if (redisClient) {
    console.log('🔌 Closing Redis connection...');
    await redisClient.quit();
    redisClient = null;
    console.log('✅ Redis connection closed');
  }
}

module.exports = {
  initializeRedis,
  getRedisClient,
  checkRedisHealth,
  closeRedis,
};
