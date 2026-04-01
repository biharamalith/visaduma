# Redis Configuration Guide

## Overview

This document describes the Redis caching and session management setup for the VisaDuma backend. Redis is used to improve performance by caching frequently accessed data and managing user sessions.

## Requirements Satisfied

- **Requirement 61.7**: Redis caching to reduce database query latency
- **Requirement 81.4**: Redis for caching and session storage

## Installation

Redis is already configured in the project. The `ioredis` package is installed as a dependency.

```bash
npm install ioredis
```

## Configuration

### Environment Variables

Add the following to your `.env` file:

```env
# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
```

For production environments, set a strong password:

```env
REDIS_PASSWORD=your_secure_redis_password
```

### Local Redis Installation

#### Windows
1. Download Redis from: https://github.com/microsoftarchive/redis/releases
2. Extract and run `redis-server.exe`
3. Default port: 6379

#### macOS
```bash
brew install redis
brew services start redis
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

#### Docker
```bash
docker run -d -p 6379:6379 --name redis redis:7-alpine
```

## Architecture

### Redis Client (`src/config/redis.js`)

The Redis client provides:
- Automatic connection management
- Reconnection with exponential backoff
- Connection health monitoring
- Error handling and logging

**Key Functions:**
- `initializeRedis()` - Initialize Redis connection
- `getRedisClient()` - Get Redis client instance
- `checkRedisHealth()` - Check connection health
- `closeRedis()` - Gracefully close connection

### Cache Service (`src/services/cacheService.js`)

High-level caching operations for common use cases.

**Basic Operations:**
- `get(key)` - Get value from cache
- `set(key, value, ttlSeconds)` - Set value with optional TTL
- `del(key)` - Delete single key
- `delPattern(pattern)` - Delete keys matching pattern
- `expire(key, ttlSeconds)` - Set expiration time
- `exists(key)` - Check if key exists
- `ttl(key)` - Get remaining TTL

**Numeric Operations:**
- `incr(key, amount)` - Increment value
- `decr(key, amount)` - Decrement value

**Set Operations:**
- `sadd(key, members)` - Add to set
- `srem(key, members)` - Remove from set
- `sismember(key, member)` - Check set membership
- `smembers(key)` - Get all set members

**Utility:**
- `flushAll()` - Clear all cache (use with caution!)

## Usage Examples

### Basic Caching

```javascript
const cacheService = require('./services/cacheService');

// Cache shop listings for 5 minutes
async function getShops(category) {
  const cacheKey = `shops:${category}`;
  
  // Try to get from cache
  let shops = await cacheService.get(cacheKey);
  
  if (shops) {
    console.log('Cache hit');
    return shops;
  }
  
  // Cache miss - fetch from database
  console.log('Cache miss');
  shops = await db.query('SELECT * FROM shops WHERE category = ?', [category]);
  
  // Store in cache for 5 minutes (300 seconds)
  await cacheService.set(cacheKey, shops, 300);
  
  return shops;
}
```

### Token Blacklist (Logout)

```javascript
const cacheService = require('./services/cacheService');

// Add token to blacklist on logout
async function logout(accessToken) {
  const tokenKey = `blacklist:${accessToken}`;
  
  // Store in blacklist for token's remaining lifetime (15 minutes)
  await cacheService.set(tokenKey, 'true', 900);
  
  return { success: true };
}

// Check if token is blacklisted
async function isTokenBlacklisted(accessToken) {
  const tokenKey = `blacklist:${accessToken}`;
  return await cacheService.exists(tokenKey);
}
```

### User Presence Tracking (Chat)

```javascript
const cacheService = require('./services/cacheService');

// Mark user as online
async function setUserOnline(userId) {
  const presenceKey = 'chat:online_users';
  await cacheService.sadd(presenceKey, userId);
  
  // Set expiry for auto-cleanup (5 minutes)
  await cacheService.expire(presenceKey, 300);
}

// Mark user as offline
async function setUserOffline(userId) {
  const presenceKey = 'chat:online_users';
  await cacheService.srem(presenceKey, userId);
}

// Check if user is online
async function isUserOnline(userId) {
  const presenceKey = 'chat:online_users';
  return await cacheService.sismember(presenceKey, userId);
}

// Get all online users
async function getOnlineUsers() {
  const presenceKey = 'chat:online_users';
  return await cacheService.smembers(presenceKey);
}
```

### Product Search Results Cache

```javascript
const cacheService = require('./services/cacheService');

async function searchProducts(query, filters) {
  const cacheKey = `search:${query}:${JSON.stringify(filters)}`;
  
  // Try cache first
  let results = await cacheService.get(cacheKey);
  
  if (results) {
    return results;
  }
  
  // Perform search
  results = await performProductSearch(query, filters);
  
  // Cache for 2 minutes (120 seconds)
  await cacheService.set(cacheKey, results, 120);
  
  return results;
}
```

### Provider Rankings Cache

```javascript
const cacheService = require('./services/cacheService');

async function getProviderRankings(category, city) {
  const cacheKey = `rankings:${category}:${city}`;
  
  // Check cache
  let rankings = await cacheService.get(cacheKey);
  
  if (rankings) {
    return rankings;
  }
  
  // Calculate rankings
  rankings = await calculateProviderRankings(category, city);
  
  // Cache for 10 minutes (600 seconds)
  await cacheService.set(cacheKey, rankings, 600);
  
  return rankings;
}

// Invalidate rankings when provider data changes
async function invalidateProviderRankings(category, city) {
  const cacheKey = `rankings:${category}:${city}`;
  await cacheService.del(cacheKey);
}
```

### Route Calculations Cache

```javascript
const cacheService = require('./services/cacheService');

async function calculateRoute(pickupLat, pickupLng, dropoffLat, dropoffLng) {
  const cacheKey = `route:${pickupLat},${pickupLng}:${dropoffLat},${dropoffLng}`;
  
  // Check cache
  let route = await cacheService.get(cacheKey);
  
  if (route) {
    return route;
  }
  
  // Call Google Maps API
  route = await googleMapsAPI.getRoute(pickupLat, pickupLng, dropoffLat, dropoffLng);
  
  // Cache for 15 minutes (900 seconds)
  await cacheService.set(cacheKey, route, 900);
  
  return route;
}
```

### Cache Invalidation Patterns

```javascript
const cacheService = require('./services/cacheService');

// Invalidate all shop caches when shop data changes
async function invalidateShopCaches(shopId) {
  // Delete specific shop cache
  await cacheService.del(`shop:${shopId}`);
  
  // Delete all shop listing caches
  await cacheService.delPattern('shops:*');
}

// Invalidate product caches when product changes
async function invalidateProductCaches(productId, shopId) {
  await cacheService.del(`product:${productId}`);
  await cacheService.delPattern(`products:shop:${shopId}:*`);
  await cacheService.delPattern('search:*');
}
```

## Health Monitoring

### Check Redis Health

```bash
# Via API endpoint
curl http://localhost:3000/health/redis
```

Response:
```json
{
  "status": "healthy",
  "latency": "2ms",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### Manual Redis Commands

```bash
# Connect to Redis CLI
redis-cli

# Check connection
PING
# Response: PONG

# View all keys
KEYS *

# Get a specific key
GET shops:electronics

# Check TTL
TTL shops:electronics

# Delete a key
DEL shops:electronics

# Flush all data (CAUTION!)
FLUSHALL
```

## Performance Considerations

### TTL Guidelines

| Use Case | Recommended TTL | Reason |
|----------|----------------|--------|
| Shop listings | 5 minutes | Moderate update frequency |
| Product search | 2 minutes | Frequent updates |
| Provider rankings | 10 minutes | Complex calculation |
| Route calculations | 15 minutes | External API cost |
| Token blacklist | Token lifetime | Security requirement |
| User presence | 5 minutes | Real-time requirement |

### Memory Management

Redis stores data in memory. Monitor memory usage:

```bash
# Check memory usage
redis-cli INFO memory

# Set max memory (in redis.conf or via command)
CONFIG SET maxmemory 256mb
CONFIG SET maxmemory-policy allkeys-lru
```

### Best Practices

1. **Use descriptive key names**: `shops:electronics` not `s:e`
2. **Set appropriate TTLs**: Prevent memory bloat
3. **Use patterns for invalidation**: `shops:*` for bulk deletion
4. **Monitor cache hit rates**: Optimize TTLs based on metrics
5. **Handle cache failures gracefully**: Always have fallback to database
6. **Avoid storing large objects**: Keep values under 1MB
7. **Use sets for membership checks**: More efficient than arrays

## Error Handling

The cache service handles errors gracefully:

- **Redis unavailable**: Operations return null/false, app continues
- **Connection errors**: Automatic reconnection with backoff
- **Parse errors**: Returns raw string if JSON parse fails
- **All errors logged**: Check console for debugging

## Testing

### Test Redis Connection

```javascript
const { checkRedisHealth } = require('./config/redis');

async function testRedis() {
  const health = await checkRedisHealth();
  console.log('Redis health:', health);
}

testRedis();
```

### Test Cache Operations

```javascript
const cacheService = require('./services/cacheService');

async function testCache() {
  // Set a value
  await cacheService.set('test:key', { message: 'Hello Redis!' }, 60);
  
  // Get the value
  const value = await cacheService.get('test:key');
  console.log('Cached value:', value);
  
  // Check TTL
  const ttl = await cacheService.ttl('test:key');
  console.log('TTL:', ttl, 'seconds');
  
  // Delete the value
  await cacheService.del('test:key');
}

testCache();
```

## Production Deployment

### AWS ElastiCache

1. Create ElastiCache Redis cluster
2. Update environment variables:
```env
REDIS_HOST=your-cluster.cache.amazonaws.com
REDIS_PORT=6379
REDIS_PASSWORD=your_secure_password
```

### Security

- Enable authentication (password)
- Use TLS/SSL for connections
- Restrict network access (VPC/Security Groups)
- Regular backups (RDB snapshots)
- Monitor memory and CPU usage

## Troubleshooting

### Connection Issues

```bash
# Check if Redis is running
redis-cli ping

# Check Redis logs
tail -f /var/log/redis/redis-server.log

# Test connection with password
redis-cli -h localhost -p 6379 -a your_password ping
```

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| ECONNREFUSED | Redis not running | Start Redis server |
| NOAUTH | Password required | Set REDIS_PASSWORD |
| OOM | Out of memory | Increase maxmemory or clear cache |
| READONLY | Replica mode | Connect to master node |

## Summary

The Redis setup provides:
- ✅ Robust connection management with auto-reconnection
- ✅ Comprehensive cache operations (get, set, delete, expire)
- ✅ Set operations for token blacklist and user presence
- ✅ Health monitoring endpoints
- ✅ Graceful error handling
- ✅ Production-ready configuration

This implementation satisfies Requirements 61.7 and 81.4 for caching and session management.
