const { getRedisClient } = require('../config/redis');

/**
 * Cache Service
 * Provides high-level caching operations for the VisaDuma platform
 * 
 * Use cases:
 * - Shop listings cache (TTL: 5 minutes)
 * - Product search results cache (TTL: 2 minutes)
 * - Provider rankings cache (TTL: 10 minutes)
 * - Route calculations cache (TTL: 15 minutes)
 * - Token blacklist for logout
 * - User presence tracking for chat
 * 
 * Satisfies Requirements:
 * - 61.7: Redis caching to reduce database query latency
 * - 81.4: Redis for caching and session storage
 */

/**
 * Get value from cache
 * @param {string} key - Cache key
 * @returns {Promise<any|null>} Parsed value or null if not found
 */
async function get(key) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      console.warn('⚠️  Redis not available, cache miss');
      return null;
    }

    const value = await redis.get(key);
    
    if (!value) {
      return null;
    }

    // Try to parse JSON, return raw string if parsing fails
    try {
      return JSON.parse(value);
    } catch {
      return value;
    }
  } catch (err) {
    console.error(`❌ Cache get error for key "${key}":`, err.message);
    return null;
  }
}

/**
 * Set value in cache with optional TTL
 * @param {string} key - Cache key
 * @param {any} value - Value to cache (will be JSON stringified)
 * @param {number} [ttlSeconds] - Time to live in seconds (optional)
 * @returns {Promise<boolean>} Success status
 */
async function set(key, value, ttlSeconds = null) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      console.warn('⚠️  Redis not available, skipping cache set');
      return false;
    }

    // Stringify value if it's an object
    const stringValue = typeof value === 'string' ? value : JSON.stringify(value);

    if (ttlSeconds) {
      await redis.setex(key, ttlSeconds, stringValue);
    } else {
      await redis.set(key, stringValue);
    }

    return true;
  } catch (err) {
    console.error(`❌ Cache set error for key "${key}":`, err.message);
    return false;
  }
}

/**
 * Delete value from cache
 * @param {string} key - Cache key
 * @returns {Promise<boolean>} Success status
 */
async function del(key) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      console.warn('⚠️  Redis not available, skipping cache delete');
      return false;
    }

    const result = await redis.del(key);
    return result > 0;
  } catch (err) {
    console.error(`❌ Cache delete error for key "${key}":`, err.message);
    return false;
  }
}

/**
 * Delete multiple keys matching a pattern
 * @param {string} pattern - Key pattern (e.g., "shops:*")
 * @returns {Promise<number>} Number of keys deleted
 */
async function delPattern(pattern) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      console.warn('⚠️  Redis not available, skipping pattern delete');
      return 0;
    }

    const keys = await redis.keys(pattern);
    
    if (keys.length === 0) {
      return 0;
    }

    const result = await redis.del(...keys);
    return result;
  } catch (err) {
    console.error(`❌ Cache pattern delete error for pattern "${pattern}":`, err.message);
    return 0;
  }
}

/**
 * Set expiration time for a key
 * @param {string} key - Cache key
 * @param {number} ttlSeconds - Time to live in seconds
 * @returns {Promise<boolean>} Success status
 */
async function expire(key, ttlSeconds) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      console.warn('⚠️  Redis not available, skipping expire');
      return false;
    }

    const result = await redis.expire(key, ttlSeconds);
    return result === 1;
  } catch (err) {
    console.error(`❌ Cache expire error for key "${key}":`, err.message);
    return false;
  }
}

/**
 * Check if key exists in cache
 * @param {string} key - Cache key
 * @returns {Promise<boolean>} True if key exists
 */
async function exists(key) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return false;
    }

    const result = await redis.exists(key);
    return result === 1;
  } catch (err) {
    console.error(`❌ Cache exists error for key "${key}":`, err.message);
    return false;
  }
}

/**
 * Get remaining TTL for a key
 * @param {string} key - Cache key
 * @returns {Promise<number>} TTL in seconds, -1 if no expiry, -2 if key doesn't exist
 */
async function ttl(key) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return -2;
    }

    return await redis.ttl(key);
  } catch (err) {
    console.error(`❌ Cache TTL error for key "${key}":`, err.message);
    return -2;
  }
}

/**
 * Increment a numeric value in cache
 * @param {string} key - Cache key
 * @param {number} [amount=1] - Amount to increment by
 * @returns {Promise<number|null>} New value after increment
 */
async function incr(key, amount = 1) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return null;
    }

    if (amount === 1) {
      return await redis.incr(key);
    } else {
      return await redis.incrby(key, amount);
    }
  } catch (err) {
    console.error(`❌ Cache increment error for key "${key}":`, err.message);
    return null;
  }
}

/**
 * Decrement a numeric value in cache
 * @param {string} key - Cache key
 * @param {number} [amount=1] - Amount to decrement by
 * @returns {Promise<number|null>} New value after decrement
 */
async function decr(key, amount = 1) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return null;
    }

    if (amount === 1) {
      return await redis.decr(key);
    } else {
      return await redis.decrby(key, amount);
    }
  } catch (err) {
    console.error(`❌ Cache decrement error for key "${key}":`, err.message);
    return null;
  }
}

/**
 * Add value to a set
 * @param {string} key - Set key
 * @param {string|string[]} members - Member(s) to add
 * @returns {Promise<number>} Number of members added
 */
async function sadd(key, members) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return 0;
    }

    const membersArray = Array.isArray(members) ? members : [members];
    return await redis.sadd(key, ...membersArray);
  } catch (err) {
    console.error(`❌ Cache sadd error for key "${key}":`, err.message);
    return 0;
  }
}

/**
 * Remove value from a set
 * @param {string} key - Set key
 * @param {string|string[]} members - Member(s) to remove
 * @returns {Promise<number>} Number of members removed
 */
async function srem(key, members) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return 0;
    }

    const membersArray = Array.isArray(members) ? members : [members];
    return await redis.srem(key, ...membersArray);
  } catch (err) {
    console.error(`❌ Cache srem error for key "${key}":`, err.message);
    return 0;
  }
}

/**
 * Check if value is member of a set
 * @param {string} key - Set key
 * @param {string} member - Member to check
 * @returns {Promise<boolean>} True if member exists in set
 */
async function sismember(key, member) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return false;
    }

    const result = await redis.sismember(key, member);
    return result === 1;
  } catch (err) {
    console.error(`❌ Cache sismember error for key "${key}":`, err.message);
    return false;
  }
}

/**
 * Get all members of a set
 * @param {string} key - Set key
 * @returns {Promise<string[]>} Array of members
 */
async function smembers(key) {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return [];
    }

    return await redis.smembers(key);
  } catch (err) {
    console.error(`❌ Cache smembers error for key "${key}":`, err.message);
    return [];
  }
}

/**
 * Flush all cache data (use with caution!)
 * @returns {Promise<boolean>} Success status
 */
async function flushAll() {
  try {
    const redis = getRedisClient();
    if (!redis) {
      return false;
    }

    await redis.flushall();
    console.log('🗑️  Cache flushed');
    return true;
  } catch (err) {
    console.error('❌ Cache flush error:', err.message);
    return false;
  }
}

module.exports = {
  get,
  set,
  del,
  delPattern,
  expire,
  exists,
  ttl,
  incr,
  decr,
  sadd,
  srem,
  sismember,
  smembers,
  flushAll,
};
