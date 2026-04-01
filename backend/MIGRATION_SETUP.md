# Database Migration System Setup

This guide walks you through setting up and using the database migration system for VisaDuma backend.

## ✅ What Has Been Implemented

The migration system includes:

1. **node-pg-migrate** - PostgreSQL migration tool
2. **Migration scripts** in `package.json`
3. **Migration configuration** (`.migrationrc.json`)
4. **Migrations directory** (`migrations/`)
5. **Initial migration** - Sets up core tables (users, refresh_tokens)
6. **Migration utilities** - Status checker and test script
7. **Comprehensive documentation** - MIGRATIONS.md guide
8. **Migration template** - For creating new migrations

## 📋 Prerequisites

Before using migrations, ensure you have:

- [x] PostgreSQL 14+ installed and running
- [x] Database created (e.g., `visaduma`)
- [x] `.env` file configured with database credentials
- [x] `DATABASE_URL` environment variable set

## 🚀 Quick Start

### Step 1: Configure Environment

Ensure your `.env` file has the following:

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

**Important:** Replace `your_password` with your actual PostgreSQL password.

### Step 2: Test Database Connection

```bash
npm run test:db
```

This verifies:
- PostgreSQL is running
- Credentials are correct
- Database exists
- PostGIS extension is available

### Step 3: Test Migration System

```bash
npm run test:migrations
```

This checks:
- Database connection
- Migration configuration
- Migration files
- Required extensions

### Step 4: Check Migration Status

```bash
npm run migrate:status
```

This displays:
- Applied migrations
- Database information
- PostGIS status
- Available commands

### Step 5: Apply Migrations

```bash
npm run migrate
```

This will:
1. Create `pgmigrations` table (if not exists)
2. Enable UUID and PostGIS extensions
3. Create `users` table (if not exists)
4. Create `refresh_tokens` table (if not exists)
5. Set up triggers for `updated_at` columns

## 📁 Project Structure

```
backend/
├── migrations/                          # Migration files
│   ├── .gitkeep                        # Ensures directory is tracked
│   ├── template.js                     # Template for new migrations
│   └── 1774962107463_initial-setup.js  # Initial migration
├── src/
│   └── utils/
│       └── migrationStatus.js          # Migration status utility
├── .migrationrc.json                   # Migration configuration
├── test-migrations.js                  # Migration system test
├── MIGRATIONS.md                       # Detailed migration guide
└── MIGRATION_SETUP.md                  # This file
```

## 🔧 Available Commands

| Command | Description |
|---------|-------------|
| `npm run migrate` | Apply all pending migrations |
| `npm run migrate:down` | Rollback last migration |
| `npm run migrate:create <name>` | Create new migration |
| `npm run migrate:status` | Show migration status |
| `npm run test:migrations` | Test migration system |

## 📝 Creating New Migrations

### Example: Add Rides Table

1. **Create migration:**
```bash
npm run migrate:create add-rides-table
```

2. **Edit the generated file** in `migrations/`:

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
  
  pgm.createIndex('rides', 'user_id');
  pgm.createIndex('rides', 'status');
};

exports.down = (pgm) => {
  pgm.dropTable('rides');
};
```

3. **Apply migration:**
```bash
npm run migrate
```

4. **Verify:**
```bash
npm run migrate:status
```

## 🔍 Initial Migration Details

The initial migration (`1774962107463_initial-setup.js`) creates:

### Extensions
- **uuid-ossp** - For generating UUIDs
- **postgis** - For geospatial queries

### Tables

#### users
- `id` (uuid, primary key)
- `full_name` (varchar)
- `email` (varchar, unique)
- `phone` (varchar)
- `password_hash` (varchar)
- `role` (varchar with check constraint)
- `avatar_url` (varchar, nullable)
- `is_verified` (boolean)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Indexes:** email, phone, role

#### refresh_tokens
- `id` (serial, primary key)
- `user_id` (uuid, foreign key to users)
- `token` (varchar, unique)
- `expires_at` (timestamp)
- `created_at` (timestamp)

**Indexes:** user_id, token, expires_at

### Functions & Triggers
- `update_updated_at_column()` - Auto-updates `updated_at` timestamp
- Trigger on `users` table to call the function

## 🛡️ Safety Features

The initial migration includes safety checks:

1. **ifNotExists** - Tables are only created if they don't exist
2. **Idempotent** - Can be run multiple times safely
3. **Reversible** - Down migration removes all changes
4. **Transactional** - All changes in a transaction (rollback on error)

## 🐛 Troubleshooting

### Issue: "Cannot connect to database"

**Solution:**
1. Check PostgreSQL is running: `pg_isready`
2. Verify credentials in `.env`
3. Test connection: `npm run test:db`

### Issue: "DATABASE_URL not set"

**Solution:**
Add to `.env`:
```env
DATABASE_URL=postgres://user:password@host:port/database
```

### Issue: "Migration already applied"

**Solution:**
This is normal. The migration system tracks applied migrations and skips them.

### Issue: "Table already exists"

**Solution:**
The initial migration uses `ifNotExists`, so this shouldn't happen. If it does, the table was created outside migrations. You can:
1. Drop the table and re-run migration
2. Skip the migration (not recommended)
3. Modify migration to handle existing tables

### Issue: "Permission denied"

**Solution:**
Ensure your PostgreSQL user has permissions:
```sql
GRANT ALL PRIVILEGES ON DATABASE visaduma TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
```

## 📚 Additional Resources

- **Detailed Guide:** See [MIGRATIONS.md](./MIGRATIONS.md) for comprehensive documentation
- **node-pg-migrate Docs:** https://salsita.github.io/node-pg-migrate/
- **PostgreSQL Docs:** https://www.postgresql.org/docs/
- **PostGIS Docs:** https://postgis.net/documentation/

## ✨ Next Steps

After setting up migrations:

1. **Create module-specific migrations:**
   - Rides module tables
   - Shops module tables
   - Services module tables
   - Wallet module tables
   - etc.

2. **Follow the workflow:**
   - Create migration: `npm run migrate:create <name>`
   - Edit migration file
   - Test locally: `npm run migrate`
   - Test rollback: `npm run migrate:down`
   - Re-apply: `npm run migrate`
   - Commit to version control

3. **Best practices:**
   - Keep migrations small and focused
   - Always write down migrations
   - Test before deploying to production
   - Backup database before production migrations

## 🎯 Success Criteria

You'll know the migration system is working when:

- [x] `npm run test:migrations` passes all checks
- [x] `npm run migrate:status` shows applied migrations
- [x] `npm run migrate` applies migrations successfully
- [x] Database has `pgmigrations` table
- [x] `users` and `refresh_tokens` tables exist
- [x] UUID and PostGIS extensions are enabled

## 📞 Support

For issues or questions:
1. Check this documentation
2. Review [MIGRATIONS.md](./MIGRATIONS.md)
3. Check migration logs
4. Test in development environment first
