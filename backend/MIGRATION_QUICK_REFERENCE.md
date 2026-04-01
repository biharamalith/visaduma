# Database Migration Quick Reference

## 🚀 Common Commands

```bash
# Check status
npm run migrate:status

# Apply all pending migrations
npm run migrate

# Rollback last migration
npm run migrate:down

# Create new migration
npm run migrate:create <name>

# Test migration system
npm run test:migrations
```

## 📝 Creating a Migration

### 1. Create Migration File
```bash
npm run migrate:create add-rides-table
```

### 2. Edit Migration File
```javascript
exports.up = (pgm) => {
  // Your schema changes here
};

exports.down = (pgm) => {
  // Reverse the changes
};
```

### 3. Apply Migration
```bash
npm run migrate
```

## 🔧 Common Operations

### Create Table
```javascript
exports.up = (pgm) => {
  pgm.createTable('rides', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('uuid_generate_v4()') },
    user_id: { type: 'uuid', notNull: true, references: 'users(id)', onDelete: 'CASCADE' },
    status: { type: 'varchar(20)', notNull: true, default: 'pending' },
    created_at: { type: 'timestamp', notNull: true, default: pgm.func('CURRENT_TIMESTAMP') },
  });
};

exports.down = (pgm) => {
  pgm.dropTable('rides');
};
```

### Add Column
```javascript
exports.up = (pgm) => {
  pgm.addColumn('users', {
    bio: { type: 'text', notNull: false },
  });
};

exports.down = (pgm) => {
  pgm.dropColumn('users', 'bio');
};
```

### Create Index
```javascript
exports.up = (pgm) => {
  pgm.createIndex('rides', 'user_id');
  pgm.createIndex('rides', ['status', 'created_at']);
};

exports.down = (pgm) => {
  pgm.dropIndex('rides', 'user_id');
  pgm.dropIndex('rides', ['status', 'created_at']);
};
```

### Add Foreign Key
```javascript
exports.up = (pgm) => {
  pgm.addConstraint('rides', 'fk_rides_driver', {
    foreignKeys: {
      columns: 'driver_id',
      references: 'users(id)',
      onDelete: 'SET NULL',
    },
  });
};

exports.down = (pgm) => {
  pgm.dropConstraint('rides', 'fk_rides_driver');
};
```

### Raw SQL
```javascript
exports.up = (pgm) => {
  pgm.sql(`
    CREATE OR REPLACE FUNCTION my_function()
    RETURNS void AS $$
    BEGIN
      -- Function logic
    END;
    $$ LANGUAGE plpgsql;
  `);
};

exports.down = (pgm) => {
  pgm.sql('DROP FUNCTION IF EXISTS my_function();');
};
```

## 🛡️ Best Practices

1. ✅ **Always write down migrations**
2. ✅ **Test locally before deploying**
3. ✅ **Use descriptive migration names**
4. ✅ **Keep migrations small and focused**
5. ✅ **Use ifNotExists/ifExists for safety**
6. ✅ **Never modify applied migrations**
7. ✅ **Backup before production migrations**
8. ✅ **Document complex migrations**

## 🔍 Column Types

```javascript
// Common PostgreSQL types
{ type: 'serial' }              // Auto-increment integer
{ type: 'uuid' }                // UUID
{ type: 'varchar(100)' }        // Variable character
{ type: 'text' }                // Unlimited text
{ type: 'integer' }             // Integer
{ type: 'decimal(10,2)' }       // Decimal with precision
{ type: 'boolean' }             // Boolean
{ type: 'timestamp' }           // Timestamp
{ type: 'date' }                // Date only
{ type: 'json' }                // JSON
{ type: 'jsonb' }               // Binary JSON (faster)
```

## 🎯 Column Options

```javascript
{
  type: 'varchar(100)',
  notNull: true,              // NOT NULL constraint
  unique: true,               // UNIQUE constraint
  default: 'value',           // Default value
  default: pgm.func('NOW()'), // Function default
  primaryKey: true,           // Primary key
  references: 'users(id)',    // Foreign key
  onDelete: 'CASCADE',        // On delete action
  check: "status IN ('a','b')", // Check constraint
}
```

## 📚 Documentation

- **Setup Guide:** [MIGRATION_SETUP.md](./MIGRATION_SETUP.md)
- **Full Guide:** [MIGRATIONS.md](./MIGRATIONS.md)
- **Summary:** [MIGRATION_SYSTEM_SUMMARY.md](./MIGRATION_SYSTEM_SUMMARY.md)

## 🐛 Troubleshooting

### Can't connect to database
```bash
# Test connection
npm run test:db

# Check .env file
# Verify DATABASE_URL is set
```

### Migration already applied
```bash
# Check status
npm run migrate:status

# This is normal - migrations are tracked
```

### Need to rollback
```bash
# Rollback last migration
npm run migrate:down

# Check status
npm run migrate:status
```

## 🔗 Quick Links

- [node-pg-migrate Docs](https://salsita.github.io/node-pg-migrate/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [PostGIS Docs](https://postgis.net/documentation/)
