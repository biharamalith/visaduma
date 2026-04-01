/**
 * Migration: Create service_providers table
 * 
 * Description: Creates the service_providers table with all required fields for the
 * service provider booking feature, including category relationship, experience tracking,
 * booking statistics, and performance metrics.
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
  // Create service_providers table
  pgm.createTable('service_providers', {
    id: {
      type: 'uuid',
      primaryKey: true,
      default: pgm.func('uuid_generate_v4()'),
    },
    user_id: {
      type: 'uuid',
      notNull: true,
      unique: true,
      references: 'users(id)',
      onDelete: 'CASCADE',
    },
    business_name: {
      type: 'varchar(200)',
      notNull: true,
    },
    description: {
      type: 'text',
      notNull: false,
    },
    category_id: {
      type: 'uuid',
      notNull: true,
      references: 'service_categories(id)',
    },
    hourly_rate: {
      type: 'decimal(10,2)',
      notNull: false,
    },
    fixed_rates: {
      type: 'jsonb',
      notNull: false,
      comment: 'JSON object with service_name: price mappings',
    },
    service_area: {
      type: 'jsonb',
      notNull: true,
      comment: 'Array of cities covered, e.g., ["Colombo", "Gampaha"]',
    },
    availability: {
      type: 'jsonb',
      notNull: false,
      comment: 'Weekly schedule in JSON format',
    },
    is_verified: {
      type: 'boolean',
      notNull: true,
      default: false,
    },
    is_available: {
      type: 'boolean',
      notNull: true,
      default: true,
    },
    rating: {
      type: 'decimal(3,2)',
      notNull: true,
      default: 5.00,
    },
    total_reviews: {
      type: 'integer',
      notNull: true,
      default: 0,
    },
    total_bookings: {
      type: 'integer',
      notNull: true,
      default: 0,
    },
    completion_rate: {
      type: 'decimal(5,2)',
      notNull: true,
      default: 100.00,
    },
    response_time_min: {
      type: 'integer',
      notNull: true,
      default: 60,
      comment: 'Average response time in minutes',
    },
    years_experience: {
      type: 'integer',
      notNull: true,
      default: 0,
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

  // Create indexes for efficient querying
  pgm.createIndex('service_providers', 'user_id', { ifNotExists: true });
  pgm.createIndex('service_providers', 'category_id', { ifNotExists: true });
  pgm.createIndex('service_providers', 'rating', { ifNotExists: true });
  pgm.createIndex('service_providers', 'is_verified', { ifNotExists: true });
  pgm.createIndex('service_providers', 'is_available', { ifNotExists: true });
  
  // Create composite index for provider ranking and filtering
  pgm.createIndex('service_providers', ['category_id', 'rating', 'is_verified'], {
    name: 'idx_providers_category_rating_verified',
    ifNotExists: true,
  });
  
  // Create full-text search index on business_name and description
  // Note: PostgreSQL uses GIN index for full-text search
  pgm.sql(`
    CREATE INDEX IF NOT EXISTS idx_providers_fulltext 
    ON service_providers 
    USING GIN (to_tsvector('english', business_name || ' ' || COALESCE(description, '')));
  `);
  
  // Create trigger for updated_at timestamp
  pgm.sql(`
    DROP TRIGGER IF EXISTS update_service_providers_updated_at ON service_providers;
    CREATE TRIGGER update_service_providers_updated_at
      BEFORE UPDATE ON service_providers
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  `);
};

/**
 * Revert migration changes
 * 
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
  // Drop trigger
  pgm.sql('DROP TRIGGER IF EXISTS update_service_providers_updated_at ON service_providers;');
  
  // Drop full-text search index
  pgm.dropIndex('service_providers', 'business_name', {
    name: 'idx_providers_fulltext',
    ifExists: true,
  });
  
  // Drop composite index
  pgm.dropIndex('service_providers', ['category_id', 'rating', 'is_verified'], {
    name: 'idx_providers_category_rating_verified',
    ifExists: true,
  });
  
  // Drop other indexes
  pgm.dropIndex('service_providers', 'is_available', { ifExists: true });
  pgm.dropIndex('service_providers', 'is_verified', { ifExists: true });
  pgm.dropIndex('service_providers', 'rating', { ifExists: true });
  pgm.dropIndex('service_providers', 'category_id', { ifExists: true });
  pgm.dropIndex('service_providers', 'user_id', { ifExists: true });
  
  // Drop table
  pgm.dropTable('service_providers', { ifExists: true, cascade: true });
};
