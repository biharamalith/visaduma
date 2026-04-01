/**
 * Migration: Create bookings table
 * 
 * Description: Creates the bookings table for service provider booking feature.
 * Includes fields for booking details, service location, payment, and status tracking.
 * 
 * @type {import('node-pg-migrate').ColumnDefinitions | undefined}
 */
exports.shorthands = undefined;

/**
 * Apply migration changes
 * 
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.up = (pgm) => {
  // Create bookings table
  pgm.createTable('bookings', {
    id: {
      type: 'uuid',
      primaryKey: true,
      default: pgm.func('uuid_generate_v4()'),
    },
    booking_number: {
      type: 'varchar(50)',
      notNull: true,
      unique: true,
    },
    user_id: {
      type: 'uuid',
      notNull: true,
      references: 'users(id)',
    },
    provider_id: {
      type: 'uuid',
      notNull: true,
      references: 'service_providers(id)',
    },
    category_id: {
      type: 'uuid',
      notNull: true,
      references: 'service_categories(id)',
    },
    status: {
      type: 'varchar(20)',
      notNull: true,
      default: 'pending',
      check: "status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled')",
    },
    service_date: {
      type: 'date',
      notNull: true,
    },
    service_time: {
      type: 'time',
      notNull: true,
    },
    duration_hours: {
      type: 'decimal(4,2)',
      notNull: true,
    },
    service_address: {
      type: 'text',
      notNull: true,
    },
    service_city: {
      type: 'varchar(100)',
      notNull: true,
    },
    service_lat: {
      type: 'decimal(10,8)',
      notNull: false,
    },
    service_lng: {
      type: 'decimal(11,8)',
      notNull: false,
    },
    contact_phone: {
      type: 'varchar(20)',
      notNull: true,
    },
    description: {
      type: 'text',
      notNull: false,
    },
    special_instructions: {
      type: 'text',
      notNull: false,
    },
    estimated_cost: {
      type: 'decimal(10,2)',
      notNull: true,
    },
    final_cost: {
      type: 'decimal(10,2)',
      notNull: false,
    },
    payment_method: {
      type: 'varchar(20)',
      notNull: true,
      default: 'cash',
      check: "payment_method IN ('cash', 'wallet', 'card')",
    },
    payment_status: {
      type: 'varchar(20)',
      notNull: true,
      default: 'pending',
      check: "payment_status IN ('pending', 'completed', 'failed', 'refunded')",
    },
    created_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
    confirmed_at: {
      type: 'timestamp',
      notNull: false,
    },
    started_at: {
      type: 'timestamp',
      notNull: false,
    },
    completed_at: {
      type: 'timestamp',
      notNull: false,
    },
    cancelled_at: {
      type: 'timestamp',
      notNull: false,
    },
    cancellation_reason: {
      type: 'text',
      notNull: false,
    },
  }, {
    ifNotExists: true,
  });

  // Create indexes
  pgm.createIndex('bookings', 'user_id', { ifNotExists: true });
  pgm.createIndex('bookings', 'provider_id', { ifNotExists: true });
  pgm.createIndex('bookings', 'status', { ifNotExists: true });
  pgm.createIndex('bookings', 'service_date', { ifNotExists: true });
  pgm.createIndex('bookings', 'booking_number', { ifNotExists: true });
};

/**
 * Revert migration changes
 * 
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
  // Drop indexes
  pgm.dropIndex('bookings', 'user_id', { ifExists: true });
  pgm.dropIndex('bookings', 'provider_id', { ifExists: true });
  pgm.dropIndex('bookings', 'status', { ifExists: true });
  pgm.dropIndex('bookings', 'service_date', { ifExists: true });
  pgm.dropIndex('bookings', 'booking_number', { ifExists: true });

  // Drop table
  pgm.dropTable('bookings', { ifExists: true, cascade: true });
};
