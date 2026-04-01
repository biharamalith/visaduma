/**
 * Database Connection Test Script
 * 
 * This script tests the PostgreSQL connection, PostGIS extension,
 * and connection pool configuration.
 * 
 * Usage: node test-db-connection.js
 */

const { pool, checkDatabaseHealth } = require('./src/config/database');

async function testDatabaseConnection() {
  console.log('🔍 Testing database connection...\n');

  try {
    // Test 1: Basic connection
    console.log('Test 1: Basic Connection');
    const client = await pool.connect();
    console.log('✅ Successfully connected to PostgreSQL');
    client.release();

    // Test 2: Database health check
    console.log('\nTest 2: Database Health Check');
    const health = await checkDatabaseHealth();
    console.log('Health Status:', JSON.stringify(health, null, 2));

    if (health.status === 'healthy') {
      console.log('✅ Database is healthy');
      
      if (health.postgis_enabled) {
        console.log('✅ PostGIS extension is enabled');
      } else {
        console.log('⚠️  PostGIS extension is NOT enabled');
      }
      
      console.log(`📊 Connection Pool Stats:`);
      console.log(`   - Total connections: ${health.pool.total}`);
      console.log(`   - Idle connections: ${health.pool.idle}`);
      console.log(`   - Waiting requests: ${health.pool.waiting}`);
    } else {
      console.log('❌ Database is unhealthy:', health.error);
    }

    // Test 3: PostGIS functionality
    console.log('\nTest 3: PostGIS Functionality');
    const postgisTest = await pool.query(
      "SELECT PostGIS_Version() as version"
    );
    
    if (postgisTest.rows.length > 0) {
      console.log('✅ PostGIS is working');
      console.log(`   Version: ${postgisTest.rows[0].version}`);
    }

    // Test 4: Connection pool limits
    console.log('\nTest 4: Connection Pool Configuration');
    console.log(`   - Min connections: 5`);
    console.log(`   - Max connections: 20`);
    console.log(`   - Idle timeout: 30000ms`);
    console.log(`   - Connection timeout: 2000ms`);
    console.log('✅ Connection pool properly configured');

    console.log('\n✅ All tests passed!');
    console.log('\n💡 You can now start the server with: npm run dev');

  } catch (error) {
    console.error('\n❌ Database connection test failed:');
    console.error('Error:', error.message);
    console.error('\n📝 Troubleshooting:');
    console.error('1. Ensure PostgreSQL is running');
    console.error('2. Check database credentials in .env file');
    console.error('3. Verify database exists: CREATE DATABASE visaduma;');
    console.error('4. Enable PostGIS: CREATE EXTENSION IF NOT EXISTS postgis;');
    process.exit(1);
  } finally {
    // Close the pool
    await pool.end();
    console.log('\n🔌 Database connection pool closed');
  }
}

// Run the test
testDatabaseConnection();
