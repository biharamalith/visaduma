# VisaDuma Backend API

Node.js + Express + PostgreSQL backend for the VisaDuma Super App.

## Prerequisites

- Node.js v18+ and npm
- PostgreSQL 14+ with PostGIS extension
- Redis (optional, for caching)

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

3. Update `.env` with your configuration values

4. Create PostgreSQL database and run migrations (see BACKEND_SETUP.md in root)

5. Start development server:
```bash
npm run dev
```

## Project Structure

```
backend/
├── src/
│   ├── routes/         # API route handlers
│   ├── controllers/    # Business logic controllers
│   ├── services/       # Service layer (business logic)
│   ├── models/         # Database models
│   ├── middleware/     # Express middleware
│   ├── utils/          # Utility functions
│   ├── config/         # Configuration files
│   └── server.js       # Application entry point
├── .env.example        # Environment variables template
├── .gitignore
├── package.json
├── tsconfig.json       # TypeScript configuration
└── README.md
```

## API Documentation

Base URL: `http://localhost:3000/api/v1`

### Authentication Endpoints
- `POST /auth/register` - Register new user
- `POST /auth/login` - User login
- `POST /auth/logout` - User logout
- `POST /auth/refresh` - Refresh access token
- `GET /auth/me` - Get current user

## Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server with nodemon
- `npm test` - Run tests
- `npm run test:db` - Test database connection and configuration
- `npm run migrate` - Apply pending database migrations
- `npm run migrate:down` - Rollback last migration
- `npm run migrate:create <name>` - Create new migration
- `npm run migrate:status` - Check migration status

## Database Migrations

The backend uses `node-pg-migrate` for database schema management. See [MIGRATIONS.md](./MIGRATIONS.md) for detailed documentation.

### Quick Start

1. **Check migration status:**
```bash
npm run migrate:status
```

2. **Apply migrations:**
```bash
npm run migrate
```

3. **Create new migration:**
```bash
npm run migrate:create add-new-table
```

### Documentation

- **[MIGRATION_SETUP.md](./MIGRATION_SETUP.md)** - Quick start guide and setup instructions
- **[MIGRATIONS.md](./MIGRATIONS.md)** - Comprehensive migration guide with examples
- **[MIGRATION_SYSTEM_SUMMARY.md](./MIGRATION_SYSTEM_SUMMARY.md)** - Implementation overview

### Migration Files

Migrations are stored in `migrations/` directory with timestamp prefixes. Each migration has:
- `up()` function - applies schema changes
- `down()` function - reverts schema changes

Example migration structure:
```javascript
exports.up = (pgm) => {
  pgm.createTable('example', {
    id: { type: 'serial', primaryKey: true },
    name: { type: 'varchar(100)', notNull: true },
  });
};

exports.down = (pgm) => {
  pgm.dropTable('example');
};
```

For complete migration guide, see [MIGRATIONS.md](./MIGRATIONS.md).

## Database Configuration

The backend uses PostgreSQL with PostGIS extension for geospatial queries. Key features:

### Connection Pooling
- **Min connections:** 5
- **Max connections:** 20
- **Idle timeout:** 30 seconds
- **Connection timeout:** 2 seconds

### PostGIS Extension
The PostGIS extension is automatically enabled when the server starts. This provides geospatial functionality for:
- Driver location tracking (rides module)
- Nearby driver search with distance calculations
- Geofencing and location-based queries
- Route optimization

### Health Checks
Two health check endpoints are available:

**Basic health check:**
```bash
GET /health
```

**Database health check:**
```bash
GET /health/db
```

Returns:
- Connection status (healthy/unhealthy)
- PostgreSQL version
- PostGIS extension status
- Connection pool statistics

### Testing Database Connection
Before starting the server, test your database connection:

```bash
npm run test:db
```

This will verify:
- PostgreSQL connection
- PostGIS extension availability
- Connection pool configuration
- Database health check functionality

## License

ISC
