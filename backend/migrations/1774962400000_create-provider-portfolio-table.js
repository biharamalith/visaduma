/**
 * Migration: Create provider_portfolio table
 * 
 * Description: Creates the provider_portfolio table to store portfolio images
 * and work samples for service providers. Includes foreign key relationship
 * with service_providers table and indexes for efficient querying.
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
  // Create provider_portfolio table
  pgm.createTable('provider_portfolio', {
    id: {
      type: 'serial',
      primaryKey: true,
    },
    provider_id: {
      type: 'uuid',
      notNull: true,
      references: 'service_providers(id)',
      onDelete: 'CASCADE',
    },
    image_url: {
      type: 'varchar(500)',
      notNull: true,
    },
    title: {
      type: 'varchar(200)',
      notNull: false,
    },
    description: {
      type: 'text',
      notNull: false,
    },
    display_order: {
      type: 'integer',
      notNull: true,
      default: 0,
    },
    created_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
  }, {
    ifNotExists: true,
  });

  // Create indexes for efficient querying
  pgm.createIndex('provider_portfolio', 'provider_id', { ifNotExists: true });
  pgm.createIndex('provider_portfolio', 'display_order', { ifNotExists: true });
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
  pgm.dropIndex('provider_portfolio', 'display_order', { ifExists: true });
  pgm.dropIndex('provider_portfolio', 'provider_id', { ifExists: true });
  
  // Drop table
  pgm.dropTable('provider_portfolio', { ifExists: true, cascade: true });
};
