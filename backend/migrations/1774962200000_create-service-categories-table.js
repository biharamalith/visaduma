/**
 * Migration: Create service_categories table
 * 
 * Description: Creates the service_categories table with multilingual support
 * and seeds it with 12 initial service categories for the service provider booking feature.
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
  // Create service_categories table
  pgm.createTable('service_categories', {
    id: {
      type: 'uuid',
      primaryKey: true,
      default: pgm.func('uuid_generate_v4()'),
    },
    name: {
      type: 'varchar(100)',
      notNull: true,
    },
    name_si: {
      type: 'varchar(100)',
      notNull: false,
      comment: 'Sinhala translation',
    },
    name_ta: {
      type: 'varchar(100)',
      notNull: false,
      comment: 'Tamil translation',
    },
    description: {
      type: 'text',
      notNull: false,
    },
    icon_name: {
      type: 'varchar(50)',
      notNull: true,
      comment: 'Material icon name',
    },
    color_hex: {
      type: 'varchar(7)',
      notNull: true,
      comment: 'Hex color code (e.g., #2563EB)',
    },
    display_order: {
      type: 'integer',
      notNull: true,
      default: 0,
    },
    is_active: {
      type: 'boolean',
      notNull: true,
      default: true,
    },
    created_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
  }, {
    ifNotExists: true,
  });

  // Create indexes
  pgm.createIndex('service_categories', 'display_order', { ifNotExists: true });
  pgm.createIndex('service_categories', 'is_active', { ifNotExists: true });

  // Seed initial 12 categories
  pgm.sql(`
    INSERT INTO service_categories (name, icon_name, color_hex, display_order, is_active) VALUES
    ('Carpenter', 'carpenter', '#8B4513', 1, true),
    ('Electrician', 'electrical_services', '#FFA500', 2, true),
    ('Plumber', 'plumbing', '#1E90FF', 3, true),
    ('Painter', 'format_paint', '#FF6347', 4, true),
    ('AC Repair', 'ac_unit', '#00CED1', 5, true),
    ('Cleaning Services', 'cleaning_services', '#32CD32', 6, true),
    ('Appliance Repair', 'home_repair_service', '#9370DB', 7, true),
    ('Pest Control', 'pest_control', '#DC143C', 8, true),
    ('Landscaping', 'yard', '#228B22', 9, true),
    ('Moving Services', 'local_shipping', '#FF8C00', 10, true),
    ('Interior Design', 'design_services', '#FF1493', 11, true),
    ('Home Security', 'security', '#2F4F4F', 12, true);
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
  // Drop indexes
  pgm.dropIndex('service_categories', 'display_order', { ifExists: true });
  pgm.dropIndex('service_categories', 'is_active', { ifExists: true });

  // Drop table
  pgm.dropTable('service_categories', { ifExists: true, cascade: true });
};
