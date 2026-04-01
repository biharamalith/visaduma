/**
 * Example Cache Usage Patterns
 * 
 * This file demonstrates how to use the cache service in real-world scenarios
 * for the VisaDuma platform.
 */

const cacheService = require('./cacheService');

/**
 * Example 1: Shop Listings Cache
 * Cache shop listings by category for 5 minutes
 */
async function getShopsByCategory(db, category) {
  const cacheKey = `shops:category:${category}`;
  
  // Try to get from cache
  let shops = await cacheService.get(cacheKey);
  
  if (shops) {
    console.log('✅ Cache hit for shops:', category);
    return shops;
  }
  
  // Cache miss - fetch from database
  console.log('❌ Cache miss for shops:', category);
  const result = await db.query(
    'SELECT * FROM shops WHERE category = $1 AND is_active = true ORDER BY rating DESC',
    [category]
  );
  shops = result.rows;
  
  // Store in cache for 5 minutes (300 seconds)
  await cacheService.set(cacheKey, shops, 300);
  
  return shops;
}

/**
 * Example 2: Product Search Results Cache
 * Cache product search results for 2 minutes
 */
async function searchProducts(db, query, filters = {}) {
  const cacheKey = `search:products:${query}:${JSON.stringify(filters)}`;
  
  // Check cache
  let results = await cacheService.get(cacheKey);
  
  if (results) {
    console.log('✅ Cache hit for search:', query);
    return results;
  }
  
  // Perform search
  console.log('❌ Cache miss for search:', query);
  // ... complex search query logic here
  const searchResults = await performProductSearch(db, query, filters);
  
  // Cache for 2 minutes (120 seconds)
  await cacheService.set(cacheKey, searchResults, 120);
  
  return searchResults;
}

/**
 * Example 3: Token Blacklist (Logout)
 * Add JWT token to blacklist when user logs out
 */
async function blacklistToken(accessToken, expiresInSeconds = 900) {
  const tokenKey = `blacklist:token:${accessToken}`;
  
  // Store in blacklist for token's remaining lifetime
  await cacheService.set(tokenKey, 'true', expiresInSeconds);
  
  console.log('🚫 Token blacklisted:', accessToken.substring(0, 20) + '...');
}

/**
 * Check if token is blacklisted
 */
async function isTokenBlacklisted(accessToken) {
  const tokenKey = `blacklist:token:${accessToken}`;
  return await cacheService.exists(tokenKey);
}

/**
 * Example 4: User Presence Tracking (Chat)
 * Track which users are currently online
 */
async function setUserOnline(userId) {
  const presenceKey = 'chat:online_users';
  
  // Add user to online set
  await cacheService.sadd(presenceKey, userId);
  
  // Set expiry for auto-cleanup (5 minutes)
  await cacheService.expire(presenceKey, 300);
  
  console.log('🟢 User online:', userId);
}

async function setUserOffline(userId) {
  const presenceKey = 'chat:online_users';
  
  // Remove user from online set
  await cacheService.srem(presenceKey, userId);
  
  console.log('⚫ User offline:', userId);
}

async function isUserOnline(userId) {
  const presenceKey = 'chat:online_users';
  return await cacheService.sismember(presenceKey, userId);
}

async function getOnlineUsers() {
  const presenceKey = 'chat:online_users';
  return await cacheService.smembers(presenceKey);
}

/**
 * Example 5: Provider Rankings Cache
 * Cache provider rankings by category and city for 10 minutes
 */
async function getProviderRankings(db, category, city) {
  const cacheKey = `rankings:providers:${category}:${city}`;
  
  // Check cache
  let rankings = await cacheService.get(cacheKey);
  
  if (rankings) {
    console.log('✅ Cache hit for provider rankings');
    return rankings;
  }
  
  // Calculate rankings (complex query)
  console.log('❌ Cache miss for provider rankings');
  rankings = await calculateProviderRankings(db, category, city);
  
  // Cache for 10 minutes (600 seconds)
  await cacheService.set(cacheKey, rankings, 600);
  
  return rankings;
}

/**
 * Example 6: Route Calculations Cache
 * Cache route calculations from Google Maps API for 15 minutes
 */
async function getRouteCalculation(pickupLat, pickupLng, dropoffLat, dropoffLng) {
  const cacheKey = `route:${pickupLat},${pickupLng}:${dropoffLat},${dropoffLng}`;
  
  // Check cache
  let route = await cacheService.get(cacheKey);
  
  if (route) {
    console.log('✅ Cache hit for route calculation');
    return route;
  }
  
  // Call Google Maps API (expensive operation)
  console.log('❌ Cache miss for route calculation, calling Google Maps API');
  route = await callGoogleMapsAPI(pickupLat, pickupLng, dropoffLat, dropoffLng);
  
  // Cache for 15 minutes (900 seconds)
  await cacheService.set(cacheKey, route, 900);
  
  return route;
}

/**
 * Example 7: Cache Invalidation
 * Invalidate related caches when data changes
 */
async function invalidateShopCaches(shopId) {
  // Delete specific shop cache
  await cacheService.del(`shop:${shopId}`);
  
  // Delete all shop listing caches (pattern matching)
  const deletedCount = await cacheService.delPattern('shops:category:*');
  
  console.log(`🗑️  Invalidated ${deletedCount} shop cache entries`);
}

async function invalidateProductCaches(productId, shopId) {
  // Delete specific product
  await cacheService.del(`product:${productId}`);
  
  // Delete shop's product listings
  await cacheService.delPattern(`products:shop:${shopId}:*`);
  
  // Delete all search caches (since product data changed)
  await cacheService.delPattern('search:products:*');
  
  console.log('🗑️  Invalidated product caches');
}

/**
 * Example 8: Rate Limiting with Redis
 * Track API request counts per user
 */
async function checkRateLimit(userId, maxRequests = 100, windowSeconds = 900) {
  const rateLimitKey = `ratelimit:${userId}`;
  
  // Get current count
  let count = await cacheService.get(rateLimitKey);
  
  if (!count) {
    // First request in window
    await cacheService.set(rateLimitKey, 1, windowSeconds);
    return { allowed: true, remaining: maxRequests - 1 };
  }
  
  count = parseInt(count);
  
  if (count >= maxRequests) {
    // Rate limit exceeded
    const ttl = await cacheService.ttl(rateLimitKey);
    return { 
      allowed: false, 
      remaining: 0,
      resetIn: ttl 
    };
  }
  
  // Increment counter
  await cacheService.incr(rateLimitKey);
  
  return { 
    allowed: true, 
    remaining: maxRequests - count - 1 
  };
}

/**
 * Example 9: Session Storage
 * Store temporary session data
 */
async function storeSessionData(sessionId, data, ttlSeconds = 3600) {
  const sessionKey = `session:${sessionId}`;
  await cacheService.set(sessionKey, data, ttlSeconds);
  console.log('💾 Session data stored:', sessionId);
}

async function getSessionData(sessionId) {
  const sessionKey = `session:${sessionId}`;
  return await cacheService.get(sessionKey);
}

async function deleteSession(sessionId) {
  const sessionKey = `session:${sessionId}`;
  await cacheService.del(sessionKey);
  console.log('🗑️  Session deleted:', sessionId);
}

/**
 * Example 10: Leaderboard with Sorted Sets
 * Track top-rated providers or shops
 */
async function updateLeaderboard(category, entityId, score) {
  const leaderboardKey = `leaderboard:${category}`;
  const redis = require('../config/redis').getRedisClient();
  
  if (redis) {
    await redis.zadd(leaderboardKey, score, entityId);
    await redis.expire(leaderboardKey, 3600); // 1 hour
  }
}

async function getTopRated(category, limit = 10) {
  const leaderboardKey = `leaderboard:${category}`;
  const redis = require('../config/redis').getRedisClient();
  
  if (redis) {
    // Get top N with scores (descending order)
    return await redis.zrevrange(leaderboardKey, 0, limit - 1, 'WITHSCORES');
  }
  
  return [];
}

// Helper functions (placeholders)
async function performProductSearch(db, query, filters) {
  // Implement actual search logic
  return [];
}

async function calculateProviderRankings(db, category, city) {
  // Implement ranking algorithm
  return [];
}

async function callGoogleMapsAPI(pickupLat, pickupLng, dropoffLat, dropoffLng) {
  // Implement Google Maps API call
  return {};
}

module.exports = {
  getShopsByCategory,
  searchProducts,
  blacklistToken,
  isTokenBlacklisted,
  setUserOnline,
  setUserOffline,
  isUserOnline,
  getOnlineUsers,
  getProviderRankings,
  getRouteCalculation,
  invalidateShopCaches,
  invalidateProductCaches,
  checkRateLimit,
  storeSessionData,
  getSessionData,
  deleteSession,
  updateLeaderboard,
  getTopRated,
};
