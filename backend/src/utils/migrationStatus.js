const { pool } = require('../config/database');
require('dotenv').config();

/**
 * Migration Status Utility
 * 
 * Displays the current status of database migrations including:
 * - Applied migrations
 * - Pending migrations
 * - Migration history
 */

async function getMigrationStatus() {
  let client;
  
  try {
    client = await pool.connect();
    
    console.log('\n📊 Database Migration Status\n');
    console.log('='.repeat(80));
    
    // Check if migrations table exists
    const tableCheck = await client.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'pgmigrations'
      ) as exists
    `);
    
    if (!tableCheck.rows[0].exists) {
      console.log('\n⚠️  No migrations have been run yet.');
      console.log('   Run "npm run migrate" to apply migrations.\n');
      return;
    }
    
    // Get applied migrations
    const appliedMigrations = await client.query(`
      SELECT id, name, run_on 
      FROM pgmigrations 
      ORDER BY run_on DESC
    `);
    
    if (appliedMigrations.rows.length === 0) {
      console.log('\n⚠️  No migrations have been applied yet.\n');
    } else {
      console.log(`\n✅ Applied Migrations (${appliedMigrations.rows.length}):\n`);
      
      appliedMigrations.rows.forEach((migration, index) => {
        const runDate = new Date(migration.run_on).toLocaleString();
        console.log(`   ${index + 1}. ${migration.name}`);
        console.log(`      ID: ${migration.id}`);
        console.log(`      Applied: ${runDate}\n`);
      });
    }
    
    // Get database info
    const dbInfo = await client.query(`
      SELECT 
        current_database() as database,
        current_user as user,
        version() as version
    `);
    
    console.log('='.repeat(80));
    console.log('\n📦 Database Information:\n');
    console.log(`   Database: ${dbInfo.rows[0].database}`);
    console.log(`   User: ${dbInfo.rows[0].user}`);
    console.log(`   Version: ${dbInfo.rows[0].version.split(',')[0]}\n`);
    
    // Check PostGIS extension
    const postgisCheck = await client.query(`
      SELECT EXISTS(
        SELECT 1 FROM pg_extension WHERE extname = 'postgis'
      ) as postgis_enabled
    `);
    
    if (postgisCheck.rows[0].postgis_enabled) {
      const postgisVersion = await client.query(`
        SELECT PostGIS_Version() as version
      `);
      console.log(`   PostGIS: ${postgisVersion.rows[0].version} ✅\n`);
    } else {
      console.log('   PostGIS: Not installed ⚠️\n');
    }
    
    console.log('='.repeat(80));
    console.log('\n💡 Migration Commands:\n');
    console.log('   npm run migrate:create <name>  - Create a new migration');
    console.log('   npm run migrate                - Apply pending migrations');
    console.log('   npm run migrate:down           - Rollback last migration');
    console.log('   npm run migrate:status         - Show this status\n');
    
  } catch (error) {
    console.error('\n❌ Error checking migration status:', error.message);
    console.error('\nMake sure:');
    console.error('  1. PostgreSQL is running');
    console.error('  2. Database credentials in .env are correct');
    console.error('  3. Database exists\n');
    process.exit(1);
  } finally {
    if (client) {
      client.release();
    }
    await pool.end();
  }
}

// Run the status check
getMigrationStatus();
