/**
 * Migration: {name}
 * 
 * Description: Add a brief description of what this migration does
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
  // Add your schema changes here
  // Examples:
  
  // Create table
  // pgm.createTable('table_name', {
  //   id: { type: 'serial', primaryKey: true },
  //   name: { type: 'varchar(100)', notNull: true },
  //   created_at: { type: 'timestamp', notNull: true, default: pgm.func('CURRENT_TIMESTAMP') },
  // });
  
  // Add column
  // pgm.addColumn('table_name', {
  //   new_column: { type: 'text', notNull: false },
  // });
  
  // Create index
  // pgm.createIndex('table_name', 'column_name');
  
  // Add foreign key
  // pgm.addConstraint('table_name', 'fk_constraint_name', {
  //   foreignKeys: {
  //     columns: 'foreign_key_column',
  //     references: 'referenced_table(id)',
  //     onDelete: 'CASCADE',
  //   },
  // });
};

/**
 * Revert migration changes
 * 
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
  // Reverse the changes made in up()
  // Examples:
  
  // Drop table
  // pgm.dropTable('table_name');
  
  // Drop column
  // pgm.dropColumn('table_name', 'new_column');
  
  // Drop index
  // pgm.dropIndex('table_name', 'column_name');
  
  // Drop constraint
  // pgm.dropConstraint('table_name', 'fk_constraint_name');
};
