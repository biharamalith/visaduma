/**
 * Migration: Create provider_certifications table
 * 
 * Description: Creates the provider_certifications table to store certifications
 * and credentials for service providers. Includes foreign key relationship
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
  // Create provider_certifications table
  pgm.createTable('provider_certifications', {
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
    certification_name: {
      type: 'varchar(200)',
      notNull: true,
    },
    issuing_org: {
      type: 'varchar(200)',
      notNull: false,
    },
    issue_date: {
      type: 'date',
      notNull: false,
    },
    expiry_date: {
      type: 'date',
      notNull: false,
    },
    document_url: {
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
  }, {
    ifNotExists: true,
  });

  // Create index for efficient querying by provider
  pgm.createIndex('provider_certifications', 'provider_id', { ifNotExists: true });
};

/**
 * Revert migration changes
 * 
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
  // Drop index
  pgm.dropIndex('provider_certifications', 'provider_id', { ifExists: true });
  
  // Drop table
  pgm.dropTable('provider_certifications', { ifExists: true, cascade: true });
};
