/**
 * Initial Database Setup Migration
 * 
 * This migration creates the core tables for the VisaDuma super app:
 * - users: User accounts with role-based access
 * - refresh_tokens: JWT refresh token storage
 * 
 * Note: These tables may already exist from the initial setup.
 * The migration checks for existence before creating.
 * 
 * @type {import('node-pg-migrate').ColumnDefinitions | undefined}
 */
exports.shorthands = undefined;

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.up = (pgm) => {
  // Enable UUID extension for generating UUIDs
  pgm.sql('CREATE EXTENSION IF NOT EXISTS "uuid-ossp";');
  
  // Enable PostGIS extension for geospatial queries
  pgm.sql('CREATE EXTENSION IF NOT EXISTS postgis;');
  
  // Create users table if not exists
  pgm.createTable('users', {
    id: {
      type: 'uuid',
      primaryKey: true,
      default: pgm.func('uuid_generate_v4()'),
    },
    full_name: {
      type: 'varchar(100)',
      notNull: true,
    },
    email: {
      type: 'varchar(150)',
      notNull: true,
      unique: true,
    },
    phone: {
      type: 'varchar(20)',
      notNull: true,
      default: '',
    },
    password_hash: {
      type: 'varchar(255)',
      notNull: true,
    },
    role: {
      type: 'varchar(20)',
      notNull: true,
      default: 'user',
      check: "role IN ('user', 'provider', 'shop_owner', 'admin')",
    },
    avatar_url: {
      type: 'varchar(500)',
      notNull: false,
    },
    is_verified: {
      type: 'boolean',
      notNull: true,
      default: false,
    },
    created_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
    updated_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
  }, {
    ifNotExists: true,
  });
  
  // Create indexes on users table
  pgm.createIndex('users', 'email', { ifNotExists: true });
  pgm.createIndex('users', 'phone', { ifNotExists: true });
  pgm.createIndex('users', 'role', { ifNotExists: true });
  
  // Create refresh_tokens table if not exists
  pgm.createTable('refresh_tokens', {
    id: {
      type: 'serial',
      primaryKey: true,
    },
    user_id: {
      type: 'uuid',
      notNull: true,
      references: 'users(id)',
      onDelete: 'CASCADE',
    },
    token: {
      type: 'varchar(512)',
      notNull: true,
      unique: true,
    },
    expires_at: {
      type: 'timestamp',
      notNull: true,
    },
    created_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
  }, {
    ifNotExists: true,
  });
  
  // Create indexes on refresh_tokens table
  pgm.createIndex('refresh_tokens', 'user_id', { ifNotExists: true });
  pgm.createIndex('refresh_tokens', 'token', { ifNotExists: true });
  pgm.createIndex('refresh_tokens', 'expires_at', { ifNotExists: true });
  
  // Create function to update updated_at timestamp
  pgm.sql(`
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = CURRENT_TIMESTAMP;
      RETURN NEW;
    END;
    $$ language 'plpgsql';
  `);
  
  // Create trigger for users table
  pgm.sql(`
    DROP TRIGGER IF EXISTS update_users_updated_at ON users;
    CREATE TRIGGER update_users_updated_at
      BEFORE UPDATE ON users
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  `);
};

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
  // Drop triggers
  pgm.sql('DROP TRIGGER IF EXISTS update_users_updated_at ON users;');
  
  // Drop function
  pgm.sql('DROP FUNCTION IF EXISTS update_updated_at_column();');
  
  // Drop tables in reverse order (respecting foreign key constraints)
  pgm.dropTable('refresh_tokens', { ifExists: true, cascade: true });
  pgm.dropTable('users', { ifExists: true, cascade: true });
  
  // Note: We don't drop extensions as they might be used by other databases
  // pgm.sql('DROP EXTENSION IF EXISTS postgis;');
  // pgm.sql('DROP EXTENSION IF EXISTS "uuid-ossp";');
};

