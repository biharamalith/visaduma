# Database Configuration Documentation

## Overview

The VisaDuma backend uses PostgreSQL with PostGIS extension for robust data storage and geospatial queries. This document describes the database configuration, connection pooling, and health monitoring implementation.

## Configuration Details

### Connection Pool Settings

The database connection pool is configured with the following parameters:

```javascript
{
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  max: 20,                      // Maximum pool size
  min: 5,                       // Minimum pool size
  idleTimeoutMillis: 30000,     // Close idle clients after 30 seconds
  connectionTimeoutMillis: 2000 // Return error after 2 seconds if connection cannot be established
}
```

### Why These Settings?

**Min: 5 connections**
- Ensures a baseline of ready connections for immediate use
- Reduces latency for incoming requests
- Balances resource usage with responsiveness

**Max: 20 connections**
- Prevents database overload
- Suitable for moderate traffic (10,000+ concurrent users)
- Can be scaled up based on load testing results

**Idle Timeout: 30 seconds**
- Releases unused connections to free resources
- Prevents connection leaks
- Maintains pool efficiency

**Connection Timeout: 2 seconds**
- Fast failure detection
- Prevents request hanging
- Improves user experience with quick error responses

## PostGIS Extension

### Automatic Initialization

The PostGIS extension is automatically enabled when the server starts:

```javascript
const initializePostGIS = async () => {
  const client = await pool.connect();
  await client.query('CREATE EXTENSION IF NOT EXISTS postgis;');
  client.release();
};
```

### Use Cases

PostGIS provides geospatial functionality for:

1. **Rides Module**
   - Driver location tracking
   - Nearby driver search with Haversine distance calculation
   - Real-time location updates
   - Route optimization

2. **Shops Module**
   - Store location mapping
   - Delivery radius calculations
   - Location-based shop discovery

3. **Services Module**
   - Service provider location tracking
   - Service area definitions
   - Distance-based pricing

4. **Vehicles Module**
   - Vehicle location tracking
   - Pickup/dropoff location management

## Health Check Endpoints

### Basic Health Check

**Endpoint:** `GET /health`

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 3600.5
}
```

### Database Health Check

**Endpoint:** `GET /health/db`

**Response (Healthy):**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "version": "PostgreSQL 14.5 on x86_64-pc-linux-gnu...",
  "postgis_enabled": true,
  "pool": {
    "total": 8,
    "idle": 5,
    "waiting": 0
  }
}
```

**Response (Unhealthy):**
```json
{
  "status": "unhealthy",
  "error": "Connection refused",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### Health Check Implementation

```javascript
const checkDatabaseHealth = async () => {
  const client = await pool.connect();
  
  // Test basic query
  const result = await client.query('SELECT NOW() as current_time, version() as pg_version');
  
  // Check PostGIS extension
  const postgisResult = await client.query(
    "SELECT EXISTS(SELECT 1 FROM pg_extension WHERE extname = 'postgis') as postgis_enabled"
  );
  
  // Get pool stats
  const poolStats = {
    total: pool.totalCount,
    idle: pool.idleCount,
    waiting: pool.waitingCount,
  };
  
  client.release();
  
  return {
    status: 'healthy',
    timestamp: result.rows[0].current_time,
    version: result.rows[0].pg_version,
    postgis_enabled: postgisResult.rows[0].postgis_enabled,
    pool: poolStats,
  };
};
```

## Connection Pool Monitoring

### Pool Statistics

The health check provides real-time pool statistics:

- **total**: Total number of connections in the pool
- **idle**: Number of idle connections available for use
- **waiting**: Number of queued requests waiting for a connection

### Interpreting Pool Stats

**Healthy Pool:**
```json
{
  "total": 8,
  "idle": 5,
  "waiting": 0
}
```
- Good balance of active and idle connections
- No queued requests
- System is handling load efficiently

**Overloaded Pool:**
```json
{
  "total": 20,
  "idle": 0,
  "waiting": 15
}
```
- All connections in use (total = max)
- No idle connections
- Requests queuing up
- **Action:** Consider increasing max pool size or optimizing queries

**Underutilized Pool:**
```json
{
  "total": 5,
  "idle": 5,
  "waiting": 0
}
```
- Only minimum connections active
- All connections idle
- Low traffic period
- Pool will scale up automatically when needed

## Error Handling

### Connection Errors

The pool emits error events for unexpected issues:

```javascript
pool.on('error', (err, client) => {
  console.error('❌ Unexpected error on idle client', err);
  process.exit(-1);
});
```

**Common Errors:**
- Network interruption
- Database server restart
- Connection timeout
- Authentication failure

### Graceful Degradation

If PostGIS initialization fails:
- Error is logged but doesn't crash the server
- Application can still start
- Geospatial features will fail gracefully
- Admin can fix PostGIS and restart

## Testing

### Database Connection Test

Run the comprehensive database test:

```bash
npm run test:db
```

**Tests performed:**
1. Basic PostgreSQL connection
2. Database health check
3. PostGIS functionality
4. Connection pool configuration

**Expected Output:**
```
🔍 Testing database connection...

Test 1: Basic Connection
✅ Successfully connected to PostgreSQL

Test 2: Database Health Check
Health Status: {
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "version": "PostgreSQL 14.5...",
  "postgis_enabled": true,
  "pool": {
    "total": 1,
    "idle": 0,
    "waiting": 0
  }
}
✅ Database is healthy
✅ PostGIS extension is enabled
📊 Connection Pool Stats:
   - Total connections: 1
   - Idle connections: 0
   - Waiting requests: 0

Test 3: PostGIS Functionality
✅ PostGIS is working
   Version: 3.2 USE_GEOS=1 USE_PROJ=1...

Test 4: Connection Pool Configuration
   - Min connections: 5
   - Max connections: 20
   - Idle timeout: 30000ms
   - Connection timeout: 2000ms
✅ Connection pool properly configured

✅ All tests passed!

💡 You can now start the server with: npm run dev

🔌 Database connection pool closed
```

## Performance Considerations

### Connection Pooling Benefits

1. **Reduced Latency**
   - Reuses existing connections
   - Eliminates connection establishment overhead
   - Faster query execution

2. **Resource Efficiency**
   - Limits database connections
   - Prevents connection exhaustion
   - Optimizes memory usage

3. **Scalability**
   - Handles concurrent requests efficiently
   - Automatic connection management
   - Graceful handling of traffic spikes

### Query Optimization

With PostGIS enabled, use spatial indexes for optimal performance:

```sql
-- Create spatial index on driver locations
CREATE INDEX idx_drivers_location ON drivers USING GIST(
  ST_MakePoint(current_lng, current_lat)::geography
);

-- Efficient nearby driver query
SELECT * FROM drivers
WHERE ST_DWithin(
  ST_MakePoint(current_lng, current_lat)::geography,
  ST_MakePoint($1, $2)::geography,
  5000  -- 5km radius
)
AND is_available = true;
```

## Requirements Satisfied

This implementation satisfies the following requirements:

### Requirement 81.3: Technology Stack Constraints
✅ Uses PostgreSQL with PostGIS extension as the primary database

### Requirement 61.10: Response Time and Latency
✅ Uses connection pooling to reduce database connection overhead
✅ Optimizes query performance with proper connection management

## Monitoring and Maintenance

### Production Monitoring

Monitor these metrics in production:

1. **Connection Pool Usage**
   - Track total, idle, and waiting connections
   - Alert if waiting > 10 for extended periods
   - Alert if total consistently at max

2. **Query Performance**
   - Monitor slow queries (> 100ms)
   - Optimize with indexes and query tuning
   - Use EXPLAIN ANALYZE for problematic queries

3. **Database Health**
   - Regular health check polling
   - Alert on unhealthy status
   - Monitor PostGIS availability

### Scaling Recommendations

**When to increase max connections:**
- Waiting connections consistently > 0
- Response times degrading under load
- Load testing shows connection bottleneck

**When to decrease max connections:**
- Database CPU/memory pressure
- Most connections idle most of the time
- Other bottlenecks identified (query performance, network)

## Troubleshooting

### Connection Refused

**Symptoms:**
- Health check returns "unhealthy"
- Error: "Connection refused"

**Solutions:**
1. Verify PostgreSQL is running: `sudo systemctl status postgresql`
2. Check database credentials in `.env`
3. Verify database exists: `psql -l`
4. Check PostgreSQL is listening on correct port

### PostGIS Not Enabled

**Symptoms:**
- `postgis_enabled: false` in health check
- Geospatial queries fail

**Solutions:**
1. Connect to database: `psql -d visaduma`
2. Enable extension: `CREATE EXTENSION IF NOT EXISTS postgis;`
3. Verify: `SELECT PostGIS_Version();`
4. Restart server

### Pool Exhaustion

**Symptoms:**
- High waiting count in pool stats
- Slow response times
- Timeout errors

**Solutions:**
1. Increase max pool size in `database.js`
2. Optimize slow queries
3. Check for connection leaks (unreleased clients)
4. Scale horizontally with read replicas

## Security Considerations

1. **Environment Variables**
   - Never commit `.env` file
   - Use strong database passwords
   - Rotate credentials regularly

2. **Connection Security**
   - Use SSL/TLS in production
   - Configure `ssl: { rejectUnauthorized: true }`
   - Restrict database access by IP

3. **Query Safety**
   - Always use parameterized queries
   - Never concatenate user input into SQL
   - Validate and sanitize all inputs

## References

- [node-postgres Documentation](https://node-postgres.com/)
- [PostGIS Documentation](https://postgis.net/documentation/)
- [PostgreSQL Connection Pooling](https://www.postgresql.org/docs/current/runtime-config-connection.html)
- [VisaDuma Design Document](.kiro/specs/visaduma-system-design/design.md)
- [VisaDuma Requirements](.kiro/specs/visaduma-system-design/requirements.md)
