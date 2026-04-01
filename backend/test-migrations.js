/**
 * Migration System Test Script
 * 
 * This script tests the database migration system by:
 * 1. Checking database connection
 * 2. Verifying migration configuration
 * 3. Displaying migration status
 */

const { pool } = require('./src/config/database');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function testMigrationSystem() {
  console.log('\n🧪 Testing Migration System\n');
  console.log('='.repeat(80));
  
  let client;
  
  try {
    // Test 1: Database Connection
    console.log('\n1️⃣  Testing Database Connection...');
    client = await pool.connect();
    console.log('   ✅ Database connection successful');
    
    // Test 2: Check DATABASE_URL
    console.log('\n2️⃣  Checking DATABASE_URL Configuration...');
    if (!process.env.DATABASE_URL) {
      console.log('   ❌ DATABASE_URL not set in .env file');
      console.log('   Add: DATABASE_URL=postgres://user:password@host:port/database');
      process.exit(1);
    }
    console.log('   ✅ DATABASE_URL is configured');
    console.log(`   📍 ${process.env.DATABASE_URL.replace(/:[^:@]+@/, ':****@')}`);
    
    // Test 3: Check migrations directory
    console.log('\n3️⃣  Checking Migrations Directory...');
    const migrationsDir = path.join(__dirname, 'migrations');
    if (!fs.existsSync(migrationsDir)) {
      console.log('   ❌ Migrations directory not found');
      process.exit(1);
    }
    
    const migrationFiles = fs.readdirSync(migrationsDir)
      .filter(f => f.endsWith('.js') && f !== 'template.js');
    
    console.log(`   ✅ Migrations directory exists`);
    console.log(`   📁 Found ${migrationFiles.length} migration file(s)`);
    
    if (migrationFiles.length > 0) {
      console.log('\n   Migration files:');
      migrationFiles.forEach((file, index) => {
        console.log(`      ${index + 1}. ${file}`);
      });
    }
    
    // Test 4: Check migration configuration
    console.log('\n4️⃣  Checking Migration Configuration...');
    const configPath = path.join(__dirname, '.migrationrc.json');
    if (!fs.existsSync(configPath)) {
      console.log('   ❌ .migrationrc.json not found');
      process.exit(1);
    }
    
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    console.log('   ✅ Migration configuration found');
    console.log(`   📋 Migrations table: ${config['migrations-table']}`);
    console.log(`   📋 Migrations directory: ${config['migrations-dir']}`);
    
    // Test 5: Check if migrations table exists
    console.log('\n5️⃣  Checking Migration History...');
    const tableCheck = await client.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'pgmigrations'
      ) as exists
    `);
    
    if (!tableCheck.rows[0].exists) {
      console.log('   ⚠️  No migrations have been run yet');
      console.log('   Run "npm run migrate" to apply migrations');
    } else {
      const migrations = await client.query(`
        SELECT COUNT(*) as count FROM pgmigrations
      `);
      console.log(`   ✅ Migration history table exists`);
      console.log(`   📊 Applied migrations: ${migrations.rows[0].count}`);
    }
    
    // Test 6: Check PostgreSQL extensions
    console.log('\n6️⃣  Checking Required Extensions...');
    
    const uuidCheck = await client.query(`
      SELECT EXISTS(
        SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp'
      ) as exists
    `);
    
    const postgisCheck = await client.query(`
      SELECT EXISTS(
        SELECT 1 FROM pg_extension WHERE extname = 'postgis'
      ) as exists
    `);
    
    if (uuidCheck.rows[0].exists) {
      console.log('   ✅ uuid-ossp extension enabled');
    } else {
      console.log('   ⚠️  uuid-ossp extension not enabled (will be enabled by migration)');
    }
    
    if (postgisCheck.rows[0].exists) {
      const version = await client.query('SELECT PostGIS_Version() as version');
      console.log(`   ✅ PostGIS extension enabled (${version.rows[0].version})`);
    } else {
      console.log('   ⚠️  PostGIS extension not enabled (will be enabled by migration)');
    }
    
    // Summary
    console.log('\n' + '='.repeat(80));
    console.log('\n✅ Migration System Test Complete!\n');
    console.log('Next steps:');
    console.log('  1. Run "npm run migrate:status" to check migration status');
    console.log('  2. Run "npm run migrate" to apply pending migrations');
    console.log('  3. Run "npm run migrate:create <name>" to create new migrations\n');
    
  } catch (error) {
    console.error('\n❌ Test Failed:', error.message);
    console.error('\nTroubleshooting:');
    console.error('  1. Ensure PostgreSQL is running');
    console.error('  2. Check database credentials in .env');
    console.error('  3. Verify DATABASE_URL format is correct');
    console.error('  4. Run "npm run test:db" to test basic connection\n');
    process.exit(1);
  } finally {
    if (client) {
      client.release();
    }
    await pool.end();
  }
}

// Run the test
testMigrationSystem();
