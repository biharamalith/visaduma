# Database Migrations Guide

This document explains how to use the database migration system for the VisaDuma backend.

## Overview

We use [node-pg-migrate](https://github.com/salsita/node-pg-migrate) for managing PostgreSQL database schema changes. This tool provides:

- **Version control** for database schema
- **Reversible migrations** (up/down)
- **Migration history tracking**
- **Safe schema changes** in production

## Prerequisites

1. PostgreSQL database running
2. Database credentials configured in `.env`
3. `DATABASE_URL` environment variable set

## Environment Setup

Add the following to your `.env` file:

```env
# Individual database connection parameters
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=visaduma

# Database URL for migrations (required by node-pg-migrate)
DATABASE_URL=postgres://postgres:your_password@localhost:5432/visaduma
```

**Format:** `postgres://username:password@host:port/database`

## Migration Commands

### Check Migration Status

View applied and pending migrations:

```bash
npm run migrate:status
```

This displays:
- List of applied migrations with timestamps
- Database information
- PostGIS extension status
- Available commands

### Create a New Migration

```bash
npm run migrate:create <migration-name>
```

**Example:**
```bash
npm run migrate:create add-rides-table
```

This creates a new migration file in `migrations/` with a timestamp prefix:
```
migrations/1774962107463_add-rides-table.js
```

### Apply Migrations

Run all pending migrations:

```bash
npm run migrate
```

This will:
1. Check for pending migrations
2. Apply them in order
3. Record them in the `pgmigrations` table
4. Display success/failure messages

### Rollback Migrations

Rollback the last applied migration:

```bash
npm run migrate:down
```

**⚠️ Warning:** Use with caution in production! Always backup data first.

## Migration File Structure

Each migration file has two functions:

```javascript
/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 */
exports.up = (pgm) => {
  // Schema changes to apply
  pgm.createTable('example', {
    id: { type: 'serial', primaryKey: true },
    name: { type: 'varchar(100)', notNull: true },
  });
};

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 */
exports.down = (pgm) => {
  // Reverse the changes
  pgm.dropTable('example');
};
```

## Common Migration Operations

### Creating Tables

```javascript
exports.up = (pgm) => {
  pgm.createTable('rides', {
    id: {
      type: 'uuid',
      primaryKey: true,
      default: pgm.func('uuid_generate_v4()'),
    },
    user_id: {
      type: 'uuid',
      notNull: true,
      references: 'users(id)',
      onDelete: 'CASCADE',
    },
    status: {
      type: 'varchar(20)',
      notNull: true,
      default: 'pending',
    },
    created_at: {
      type: 'timestamp',
      notNull: true,
      default: pgm.func('CURRENT_TIMESTAMP'),
    },
  });
};
```

### Adding Columns

```javascript
exports.up = (pgm) => {
  pgm.addColumn('users', {
    bio: {
      type: 'text',
      notNull: false,
    },
  });
};

exports.down = (pgm) => {
  pgm.dropColumn('users', 'bio');
};
```

### Creating Indexes

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

### Adding Foreign Keys

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

### Creating Enums

```javascript
exports.up = (pgm) => {
  pgm.createType('ride_status', ['pending', 'accepted', 'in_progress', 'completed', 'cancelled']);
  
  pgm.alterColumn('rides', 'status', {
    type: 'ride_status',
    using: 'status::ride_status',
  });
};

exports.down = (pgm) => {
  pgm.alterColumn('rides', 'status', {
    type: 'varchar(20)',
  });
  
  pgm.dropType('ride_status');
};
```

### Adding Geospatial Columns (PostGIS)

```javascript
exports.up = (pgm) => {
  // Add geometry column for point location
  pgm.sql(`
    ALTER TABLE drivers 
    ADD COLUMN location GEOMETRY(Point, 4326);
  `);
  
  // Create spatial index
  pgm.sql(`
    CREATE INDEX idx_drivers_location 
    ON drivers USING GIST(location);
  `);
};

exports.down = (pgm) => {
  pgm.dropColumn('drivers', 'location');
};
```

### Running Raw SQL

```javascript
exports.up = (pgm) => {
  pgm.sql(`
    CREATE OR REPLACE FUNCTION calculate_distance(
      lat1 DECIMAL, lng1 DECIMAL,
      lat2 DECIMAL, lng2 DECIMAL
    ) RETURNS DECIMAL AS $$
    BEGIN
      RETURN 6371 * acos(
        cos(radians(lat1)) * cos(radians(lat2)) *
        cos(radians(lng2) - radians(lng1)) +
        sin(radians(lat1)) * sin(radians(lat2))
      );
    END;
    $$ LANGUAGE plpgsql IMMUTABLE;
  `);
};

exports.down = (pgm) => {
  pgm.sql('DROP FUNCTION IF EXISTS calculate_distance;');
};
```

## Best Practices

### 1. Always Write Down Migrations

Every `up` migration should have a corresponding `down` migration that reverses the changes.

### 2. Test Migrations Locally

Before deploying:
```bash
# Apply migration
npm run migrate

# Test your application
npm run dev

# Rollback to test down migration
npm run migrate:down

# Re-apply to ensure it works
npm run migrate
```

### 3. Use Transactions

Migrations run in transactions by default. If any operation fails, the entire migration is rolled back.

### 4. Avoid Data Loss

When dropping columns or tables, ensure data is backed up or migrated elsewhere first.

### 5. Keep Migrations Small

Create focused migrations that do one thing. This makes them easier to understand and rollback.

### 6. Use Descriptive Names

```bash
# Good
npm run migrate:create add-rides-table
npm run migrate:create add-driver-rating-column
npm run migrate:create create-orders-indexes

# Bad
npm run migrate:create update
npm run migrate:create fix
npm run migrate:create changes
```

### 7. Never Modify Applied Migrations

Once a migration is applied (especially in production), never modify it. Create a new migration instead.

### 8. Check for Existing Objects

Use `ifNotExists` and `ifExists` options to make migrations idempotent:

```javascript
pgm.createTable('users', { /* ... */ }, { ifNotExists: true });
pgm.dropTable('old_table', { ifExists: true });
```

## Production Deployment

### Pre-Deployment Checklist

- [ ] Test migrations locally
- [ ] Test rollback (down migration)
- [ ] Backup production database
- [ ] Review migration for data loss risks
- [ ] Check for long-running operations
- [ ] Verify foreign key constraints
- [ ] Test with production-like data volume

### Deployment Steps

1. **Backup Database**
   ```bash
   pg_dump -h localhost -U postgres -d visaduma > backup_$(date +%Y%m%d_%H%M%S).sql
   ```

2. **Apply Migrations**
   ```bash
   npm run migrate
   ```

3. **Verify Success**
   ```bash
   npm run migrate:status
   ```

4. **Test Application**
   - Run smoke tests
   - Check critical features
   - Monitor error logs

### Rollback Plan

If issues occur:

1. **Rollback Migration**
   ```bash
   npm run migrate:down
   ```

2. **Restore from Backup** (if needed)
   ```bash
   psql -h localhost -U postgres -d visaduma < backup_20240128_120000.sql
   ```

## Troubleshooting

### Migration Fails

**Error:** `relation "users" already exists`

**Solution:** Use `ifNotExists` option:
```javascript
pgm.createTable('users', { /* ... */ }, { ifNotExists: true });
```

### Cannot Connect to Database

**Error:** `connection refused`

**Solution:**
1. Check PostgreSQL is running
2. Verify `DATABASE_URL` in `.env`
3. Test connection: `npm run test:db`

### Migration Stuck

**Error:** Migration hangs indefinitely

**Solution:**
1. Check for long-running queries: `SELECT * FROM pg_stat_activity;`
2. Kill blocking queries if safe
3. Ensure no table locks exist

### Rollback Fails

**Error:** Cannot rollback due to dependent objects

**Solution:**
1. Check for foreign key constraints
2. Use `cascade: true` in down migration
3. Drop dependent objects first

## Migration History

The `pgmigrations` table tracks all applied migrations:

```sql
SELECT * FROM pgmigrations ORDER BY run_on DESC;
```

Columns:
- `id`: Migration sequence number
- `name`: Migration filename
- `run_on`: Timestamp when applied

## Additional Resources

- [node-pg-migrate Documentation](https://salsita.github.io/node-pg-migrate/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostGIS Documentation](https://postgis.net/documentation/)

## Support

For issues or questions:
1. Check this documentation
2. Review migration logs
3. Test in development environment
4. Contact the backend team
