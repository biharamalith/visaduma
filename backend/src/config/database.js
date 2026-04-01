const { Pool } = require('pg');
require('dotenv').config();

// PostgreSQL connection pool configuration
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  max: 20, // Maximum pool size
  min: 5,  // Minimum pool size
  idleTimeoutMillis: 30000, // Close idle clients after 30 seconds
  connectionTimeoutMillis: 2000, // Return error after 2 seconds if connection cannot be established
});

// Connection event handlers
pool.on('connect', (client) => {
  console.log('✅ Connected to PostgreSQL database');
});

pool.on('error', (err, client) => {
  console.error('❌ Unexpected error on idle client', err);
  process.exit(-1);
});

// Initialize PostGIS extension
const initializePostGIS = async () => {
  try {
    const client = await pool.connect();
    try {
      // Enable PostGIS extension for geospatial queries
      await client.query('CREATE EXTENSION IF NOT EXISTS postgis;');
      console.log('✅ PostGIS extension enabled');
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('❌ Error initializing PostGIS:', err.message);
    // Don't exit - allow app to start even if PostGIS setup fails
  }
};

// Database health check function
const checkDatabaseHealth = async () => {
  try {
    const client = await pool.connect();
    try {
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
      
      return {
        status: 'healthy',
        timestamp: result.rows[0].current_time,
        version: result.rows[0].pg_version,
        postgis_enabled: postgisResult.rows[0].postgis_enabled,
        pool: poolStats,
      };
    } finally {
      client.release();
    }
  } catch (err) {
    return {
      status: 'unhealthy',
      error: err.message,
      timestamp: new Date().toISOString(),
    };
  }
};

// Initialize PostGIS on module load
initializePostGIS();

module.exports = {
  pool,
  checkDatabaseHealth,
};
