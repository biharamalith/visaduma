# Core Tables Schema Documentation

## Overview

This document describes the core database tables for the VisaDuma super app authentication system. These tables were created by the initial migration (`1774962107463_initial-setup.js`) and provide the foundation for user management and authentication.

## Requirements Coverage

This schema satisfies the following requirements from the VisaDuma System Design specification:

- **Requirement 4.1**: User account creation with full name, email, phone, and password
- **Requirement 4.2**: Password hashing using bcrypt (implemented in application layer)
- **Requirement 4.3**: Unique user ID generation using UUID

## Database Extensions

### uuid-ossp
Provides UUID generation functions for creating unique identifiers.

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### PostGIS
Enables geospatial queries for location-based features (rides, services, etc.).

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

## Tables

### 1. users

The `users` table stores all user accounts across the platform, supporting multiple roles (user, provider, shop_owner, admin).

#### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | uuid | PRIMARY KEY, DEFAULT uuid_generate_v4() | Unique user identifier |
| `full_name` | varchar(100) | NOT NULL | User's full name |
| `email` | varchar(150) | NOT NULL, UNIQUE | User's email address (login credential) |
| `phone` | varchar(20) | NOT NULL, DEFAULT '' | User's phone number |
| `password_hash` | varchar(255) | NOT NULL | Bcrypt hashed password |
| `role` | varchar(20) | NOT NULL, DEFAULT 'user', CHECK | User role: user, provider, shop_owner, or admin |
| `avatar_url` | varchar(500) | NULL | URL to user's profile picture |
| `is_verified` | boolean | NOT NULL, DEFAULT false | Email/phone verification status |
| `created_at` | timestamp | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Account creation timestamp |
| `updated_at` | timestamp | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp (auto-updated) |

#### Indexes

- `idx_users_email`: Fast lookup by email (login)
- `idx_users_phone`: Fast lookup by phone number
- `idx_users_role`: Fast filtering by user role

#### Constraints

- **UNIQUE**: `email` must be unique across all users
- **CHECK**: `role` must be one of: 'user', 'provider', 'shop_owner', 'admin'

#### Triggers

- `update_users_updated_at`: Automatically updates `updated_at` timestamp on row modification

#### Example Query

```sql
-- Create a new user
INSERT INTO users (full_name, email, phone, password_hash, role)
VALUES ('John Doe', 'john@example.com', '+94771234567', '$2a$10$...', 'user');

-- Find user by email
SELECT * FROM users WHERE email = 'john@example.com';

-- Update user profile
UPDATE users 
SET full_name = 'John Smith', avatar_url = 'https://cdn.example.com/avatar.jpg'
WHERE id = 'uuid-here';
```

### 2. refresh_tokens

The `refresh_tokens` table stores JWT refresh tokens for secure session management with token rotation.

#### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | serial | PRIMARY KEY | Auto-incrementing token ID |
| `user_id` | uuid | NOT NULL, FOREIGN KEY → users(id) | Reference to user who owns this token |
| `token` | varchar(512) | NOT NULL, UNIQUE | The refresh token string |
| `expires_at` | timestamp | NOT NULL | Token expiration timestamp (7 days) |
| `created_at` | timestamp | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Token creation timestamp |

#### Indexes

- `idx_refresh_tokens_user_id`: Fast lookup of all tokens for a user
- `idx_refresh_tokens_token`: Fast token validation
- `idx_refresh_tokens_expires_at`: Fast cleanup of expired tokens

#### Foreign Keys

- `user_id` → `users(id)` with `ON DELETE CASCADE`: Deletes all tokens when user is deleted

#### Constraints

- **UNIQUE**: `token` must be unique across all refresh tokens

#### Example Query

```sql
-- Store a new refresh token
INSERT INTO refresh_tokens (user_id, token, expires_at)
VALUES ('user-uuid', 'refresh-token-string', NOW() + INTERVAL '7 days');

-- Validate and retrieve refresh token
SELECT rt.*, u.id, u.email, u.role
FROM refresh_tokens rt
JOIN users u ON rt.user_id = u.id
WHERE rt.token = 'refresh-token-string'
  AND rt.expires_at > NOW();

-- Invalidate all tokens for a user (logout)
DELETE FROM refresh_tokens WHERE user_id = 'user-uuid';

-- Clean up expired tokens (maintenance job)
DELETE FROM refresh_tokens WHERE expires_at < NOW();
```

## Database Functions

### update_updated_at_column()

Automatically updates the `updated_at` timestamp when a row is modified.

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$ language 'plpgsql';
```

This function is attached to the `users` table via a trigger:

```sql
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

## Authentication Flow

### Registration Flow

1. User submits registration form (full_name, email, phone, password)
2. Application validates input and checks for existing email
3. Application hashes password using bcrypt (cost factor 10)
4. Application inserts new record into `users` table
5. Database generates UUID for `id` field
6. Application generates JWT access token (15-minute expiry)
7. Application generates refresh token (7-day expiry)
8. Application stores refresh token in `refresh_tokens` table
9. Application returns user data and tokens to client

### Login Flow

1. User submits login credentials (email, password)
2. Application queries `users` table by email
3. Application verifies password using bcrypt comparison
4. Application generates new JWT access token
5. Application generates new refresh token
6. Application stores refresh token in `refresh_tokens` table
7. Application returns user data and tokens to client

### Token Refresh Flow

1. Client sends expired access token + valid refresh token
2. Application validates refresh token against `refresh_tokens` table
3. Application checks token expiration
4. Application generates new access token
5. Application rotates refresh token (optional)
6. Application returns new tokens to client

### Logout Flow

1. Client sends logout request with access token
2. Application identifies user from JWT
3. Application deletes all refresh tokens for user
4. Application adds access token to Redis blacklist
5. Client discards stored tokens

## Security Considerations

### Password Security
- Passwords are **never** stored in plain text
- Bcrypt hashing with cost factor 10 (application layer)
- Password hash stored in `password_hash` column (255 chars)

### Token Security
- Access tokens: 15-minute expiry (short-lived)
- Refresh tokens: 7-day expiry (long-lived)
- Refresh token rotation on use (prevents replay attacks)
- Token blacklisting via Redis for immediate logout
- HTTPS required for all authentication endpoints

### Database Security
- Foreign key constraints ensure referential integrity
- Cascade deletion removes orphaned tokens
- Indexes optimize query performance
- Unique constraints prevent duplicate accounts

## Maintenance

### Cleanup Expired Tokens

Run periodically (e.g., daily cron job):

```sql
DELETE FROM refresh_tokens WHERE expires_at < NOW();
```

### Monitor Token Usage

```sql
-- Count active tokens per user
SELECT user_id, COUNT(*) as token_count
FROM refresh_tokens
WHERE expires_at > NOW()
GROUP BY user_id
ORDER BY token_count DESC;

-- Find users with many active sessions
SELECT u.email, COUNT(rt.id) as active_sessions
FROM users u
LEFT JOIN refresh_tokens rt ON u.id = rt.user_id AND rt.expires_at > NOW()
GROUP BY u.id, u.email
HAVING COUNT(rt.id) > 5;
```

## Migration Information

- **Migration File**: `backend/migrations/1774962107463_initial-setup.js`
- **Created**: Initial setup migration
- **Status**: Applied
- **Rollback**: Available via `npm run migrate:down`

## Related Documentation

- [MIGRATIONS.md](./MIGRATIONS.md) - Complete migration system guide
- [MIGRATION_QUICK_REFERENCE.md](./MIGRATION_QUICK_REFERENCE.md) - Quick command reference
- [DATABASE_CONFIGURATION.md](./DATABASE_CONFIGURATION.md) - Database setup guide
- [Requirements Document](./.kiro/specs/visaduma-system-design/requirements.md) - System requirements
- [Design Document](./.kiro/specs/visaduma-system-design/design.md) - System design

## Future Extensions

These core tables will be extended with additional tables for:
- Rides (drivers, rides, ride_locations)
- Shops (shops, products, orders, cart_items)
- Services (service_providers, bookings)
- Wallet (wallets, transactions)
- Chat (conversations, messages)
- Reviews (reviews table)
- And more...

All future tables will reference the `users` table via foreign keys to maintain data integrity.
