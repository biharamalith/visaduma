# Backend Setup Instructions

## Quick Start

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Configure Environment Variables

The `.env` file has been created with default values. Update the following:

**Required:**
- `DB_PASSWORD` - Your PostgreSQL password
- `JWT_SECRET` - Change to a secure random string in production

**Optional (for full functionality):**
- AWS credentials for file uploads
- Google Maps API key for location services
- Firebase credentials for push notifications
- Redis configuration for caching

### 3. Setup PostgreSQL Database

Refer to the main `BACKEND_SETUP.md` in the project root for complete database setup instructions.

Quick setup:
```sql
CREATE DATABASE visaduma WITH ENCODING 'UTF8';
\c visaduma
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

**Note:** The PostGIS extension is automatically enabled when the server starts. The database configuration includes:
- Connection pooling (min: 5, max: 20 connections)
- Automatic PostGIS extension initialization
- Connection health monitoring
- Proper error handling and reconnection logic

Then run the SQL schema from `BACKEND_SETUP.md`.

### 4. Start the Server

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

The server will start at `http://localhost:3000`

### 5. Test the API

Health check:
```bash
curl http://localhost:3000/health
```

Database health check:
```bash
curl http://localhost:3000/health/db
```

The database health check will return:
- Connection status (healthy/unhealthy)
- PostgreSQL version
- PostGIS extension status
- Connection pool statistics (total, idle, waiting connections)

Register a user:
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "Test User",
    "email": "test@example.com",
    "phone": "0712345678",
    "password": "password123",
    "role": "user"
  }'
```

Login:
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # PostgreSQL connection pool with PostGIS support
│   ├── controllers/             # Business logic controllers (empty, ready for modules)
│   ├── middleware/
│   │   ├── auth.js              # JWT authentication middleware
│   │   └── errorHandler.js      # Global error handler
│   ├── models/                  # Database models (empty, ready for modules)
│   ├── routes/
│   │   └── auth.js              # Authentication routes
│   ├── services/                # Service layer (empty, ready for modules)
│   ├── utils/
│   │   ├── formatters.js        # Data formatting utilities
│   │   └── jwt.js               # JWT token utilities
│   └── server.js                # Application entry point
├── .env                         # Environment variables (configured)
├── .env.example                 # Environment template
├── .gitignore                   # Git ignore rules
├── package.json                 # Dependencies and scripts
├── tsconfig.json                # TypeScript configuration
└── README.md                    # Project documentation
```

## Available Dependencies

The following packages are already installed:

**Core:**
- `express` - Web framework
- `pg` - PostgreSQL client
- `dotenv` - Environment variables

**Authentication & Security:**
- `bcryptjs` - Password hashing
- `jsonwebtoken` - JWT tokens
- `helmet` - Security headers
- `cors` - CORS middleware
- `express-rate-limit` - Rate limiting

**File Upload & Storage:**
- `multer` - File upload handling
- `aws-sdk` - AWS S3 integration

**Real-time:**
- `socket.io` - WebSocket support

**Development:**
- `nodemon` - Auto-reload on file changes

## Next Steps

The backend is now ready for module implementation:

1. **Rides Module** - Add routes, controllers, and services for ride-hailing
2. **Shops Module** - Add e-commerce functionality
3. **Services Module** - Add on-demand services booking
4. **Wallet Module** - Add VisaPay digital wallet
5. **Chat Module** - Add real-time messaging with Socket.IO
6. **Jobs Module** - Add job marketplace
7. **Vehicles Module** - Add vehicle rental marketplace

Each module should follow the structure:
- Routes in `src/routes/`
- Controllers in `src/controllers/`
- Services in `src/services/`
- Models in `src/models/`

## Connecting Flutter App

Update Flutter app's API endpoint:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000/api/v1';
```

**For Physical Device:**
```dart
static const String baseUrl = 'http://YOUR_PC_IP:3000/api/v1';
```

## Troubleshooting

**Database connection fails:**
- Verify PostgreSQL is running
- Check DB credentials in `.env`
- Ensure database exists

**Port already in use:**
- Change `PORT` in `.env`
- Or kill the process using port 3000

**Module not found errors:**
- Run `npm install` again
- Delete `node_modules` and reinstall

## Security Notes

⚠️ **Before deploying to production:**

1. Change `JWT_SECRET` to a strong random string
2. Set `NODE_ENV=production`
3. Use HTTPS only
4. Configure proper CORS origins
5. Set up proper rate limiting
6. Enable database SSL connections
7. Secure all API keys and credentials
8. Review and update security headers

## Support

For detailed backend architecture and API documentation, refer to:
- Main project `BACKEND_SETUP.md`
- Design document: `.kiro/specs/visaduma-system-design/design.md`
- Requirements: `.kiro/specs/visaduma-system-design/requirements.md`
