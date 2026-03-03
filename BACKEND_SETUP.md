# VisaDuma — Backend Setup Guide
> Node.js + Express + MySQL → wired to the Flutter app

---

## Table of Contents
1. [Install Required Tools](#1-install-required-tools)
2. [Create the MySQL Database](#2-create-the-mysql-database)
3. [Create the Node.js Server](#3-create-the-nodejs-server)
4. [Project File Structure](#4-project-file-structure)
5. [Full Server Code](#5-full-server-code)
6. [How Authentication Works](#6-how-authentication-works)
7. [Exact JSON Shapes Flutter Expects](#7-exact-json-shapes-flutter-expects)
8. [Wire Flutter to the Server](#8-wire-flutter-to-the-server)
9. [Run & Test](#9-run--test)

---

## 1. Install Required Tools

### Node.js
Download and install from https://nodejs.org (LTS version)

Verify:
```bash
node -v   # e.g. v20.x.x
npm -v    # e.g. 10.x.x
```

### MySQL
Download **MySQL Community Server** from https://dev.mysql.com/downloads/mysql/

During install:
- Set root password (remember this — you'll need it)
- Choose "Developer Default" setup type

Optionally install **MySQL Workbench** (GUI tool) from the same page.

---

## 2. Create the MySQL Database

Open MySQL Workbench or run `mysql -u root -p` in terminal, then run:

```sql
-- Create the database
CREATE DATABASE visaduma CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE visaduma;

-- Users table
CREATE TABLE users (
  id            VARCHAR(36)  PRIMARY KEY DEFAULT (UUID()),
  full_name     VARCHAR(100) NOT NULL,
  email         VARCHAR(150) NOT NULL UNIQUE,
  phone         VARCHAR(20)  NOT NULL DEFAULT '',
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('user','provider','shop_owner','admin') NOT NULL DEFAULT 'user',
  avatar_url    VARCHAR(500) NULL,
  is_verified   TINYINT(1)   NOT NULL DEFAULT 0,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Refresh tokens table (for JWT rotation)
CREATE TABLE refresh_tokens (
  id         INT          PRIMARY KEY AUTO_INCREMENT,
  user_id    VARCHAR(36)  NOT NULL,
  token      VARCHAR(512) NOT NULL UNIQUE,
  expires_at DATETIME     NOT NULL,
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert a test user (password = 123456)
INSERT INTO users (full_name, email, phone, password_hash, role, is_verified)
VALUES (
  'Dev User',
  'user@gmail.com',
  '0712345678',
  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- bcrypt of "123456"
  'user',
  1
);
```

---

## 3. Create the Node.js Server

```bash
# Create a folder next to (or separate from) your Flutter project
mkdir visaduma-backend
cd visaduma-backend

# Initialise npm
npm init -y

# Install dependencies
npm install express mysql2 bcryptjs jsonwebtoken cors dotenv uuid

# Install dev dependencies
npm install --save-dev nodemon
```

---

## 4. Project File Structure

```
visaduma-backend/
├── .env
├── package.json
├── server.js            ← entry point
├── db.js                ← MySQL connection pool
├── middleware/
│   └── auth.js          ← JWT verification middleware
└── routes/
    └── auth.js          ← /api/v1/auth/* routes
```

---

## 5. Full Server Code

### `.env`
```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_root_password_here
DB_NAME=visaduma
JWT_SECRET=super_secret_key_change_this_in_production
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
```

---

### `db.js`
```js
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host:     process.env.DB_HOST,
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

module.exports = pool;
```

---

### `middleware/auth.js`
```js
const jwt = require('jsonwebtoken');

module.exports = function requireAuth(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'Unauthorised.' });
  }
  const token = header.split(' ')[1];
  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ success: false, message: 'Token expired or invalid.' });
  }
};
```

---

### `routes/auth.js`
```js
const express  = require('express');
const bcrypt   = require('bcryptjs');
const jwt      = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const db       = require('../db');
const requireAuth = require('../middleware/auth');

const router = express.Router();

// ── Helpers ────────────────────────────────────────────────

// Map a DB row to the exact JSON shape Flutter expects
function formatUser(row) {
  return {
    id:         row.id,
    fullName:   row.full_name,       // Flutter reads "fullName"
    email:      row.email,
    phone:      row.phone,
    role:       row.role,
    avatarUrl:  row.avatar_url,      // Flutter reads "avatarUrl"
    isVerified: row.is_verified === 1,  // Flutter reads "isVerified"
    createdAt:  row.created_at instanceof Date
                  ? row.created_at.toISOString()
                  : row.created_at,   // Flutter reads "createdAt" (ISO string)
  };
}

function signAccessToken(userId) {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
}

async function saveRefreshToken(userId, token) {
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days
  await db.execute(
    'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, ?)',
    [userId, token, expiresAt]
  );
}

// ── POST /api/v1/auth/register ──────────────────────────────
router.post('/register', async (req, res) => {
  const { full_name, email, phone, password, role } = req.body;

  if (!full_name || !email || !password) {
    return res.status(422).json({ success: false, message: 'full_name, email and password are required.' });
  }

  const [existing] = await db.execute('SELECT id FROM users WHERE email = ?', [email]);
  if (existing.length > 0) {
    return res.status(422).json({ success: false, message: 'Email already in use.' });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const id = uuidv4();

  await db.execute(
    'INSERT INTO users (id, full_name, email, phone, password_hash, role) VALUES (?, ?, ?, ?, ?, ?)',
    [id, full_name, email, phone || '', passwordHash, role || 'user']
  );

  const [rows] = await db.execute('SELECT * FROM users WHERE id = ?', [id]);
  const user = rows[0];

  const accessToken  = signAccessToken(user.id);
  const refreshToken = jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_REFRESH_EXPIRES_IN,
  });
  await saveRefreshToken(user.id, refreshToken);

  return res.status(201).json({
    success: true,
    data: {
      user:          formatUser(user),
      access_token:  accessToken,
      refresh_token: refreshToken,
    },
  });
});

// ── POST /api/v1/auth/login ────────────────────────────────
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(422).json({ success: false, message: 'Email and password are required.' });
  }

  const [rows] = await db.execute('SELECT * FROM users WHERE email = ?', [email]);
  const user = rows[0];

  if (!user || !(await bcrypt.compare(password, user.password_hash))) {
    return res.status(401).json({ success: false, message: 'Invalid email or password.' });
  }

  const accessToken  = signAccessToken(user.id);
  const refreshToken = jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_REFRESH_EXPIRES_IN,
  });
  await saveRefreshToken(user.id, refreshToken);

  return res.json({
    success: true,
    data: {
      user:          formatUser(user),
      access_token:  accessToken,
      refresh_token: refreshToken,
    },
  });
});

// ── POST /api/v1/auth/logout ───────────────────────────────
router.post('/logout', requireAuth, async (req, res) => {
  const token = req.headers.authorization?.split(' ')[1];
  // Delete all refresh tokens for this user (or just the specific one)
  await db.execute('DELETE FROM refresh_tokens WHERE user_id = ?', [req.user.id]);
  return res.json({ success: true, message: 'Logged out.' });
});

// ── POST /api/v1/auth/refresh ──────────────────────────────
router.post('/refresh', async (req, res) => {
  const { refresh_token } = req.body;
  if (!refresh_token) {
    return res.status(401).json({ success: false, message: 'Refresh token missing.' });
  }
  try {
    const payload = jwt.verify(refresh_token, process.env.JWT_SECRET);
    const [rows] = await db.execute(
      'SELECT * FROM refresh_tokens WHERE user_id = ? AND token = ? AND expires_at > NOW()',
      [payload.id, refresh_token]
    );
    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid or expired refresh token.' });
    }
    const newAccess = signAccessToken(payload.id);
    return res.json({ success: true, data: { access_token: newAccess } });
  } catch {
    return res.status(401).json({ success: false, message: 'Invalid refresh token.' });
  }
});

// ── GET /api/v1/auth/me ────────────────────────────────────
router.get('/me', requireAuth, async (req, res) => {
  const [rows] = await db.execute('SELECT * FROM users WHERE id = ?', [req.user.id]);
  if (rows.length === 0) {
    return res.status(404).json({ success: false, message: 'User not found.' });
  }
  return res.json({ success: true, data: { user: formatUser(rows[0]) } });
});

module.exports = router;
```

---

### `server.js`
```js
const express = require('express');
const cors    = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/auth');

const app = express();

app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (_, res) => res.json({ status: 'ok' }));

// Routes
app.use('/api/v1/auth', authRoutes);

// 404 handler
app.use((req, res) => res.status(404).json({ success: false, message: 'Route not found.' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ VisaDuma API running at http://localhost:${PORT}`);
});
```

---

### `package.json` scripts section
```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}
```

---

## 6. How Authentication Works

```
┌──────────────┐     POST /auth/login         ┌─────────────────┐
│ Flutter App  │  ──────────────────────────▶  │  Node.js API    │
│              │   { email, password }         │                 │
│              │                               │  1. Query MySQL │
│              │                               │  2. bcrypt.compare(pw, hash) │
│              │  ◀──────────────────────────  │  3. Sign JWTs   │
│              │   { data: {                   │                 │
│              │     user: {...},              └─────────────────┘
│              │     access_token: "eyJ...",
│              │     refresh_token: "eyJ..."
│              │   }}
│              │
│  Stores tokens in SharedPreferences
│  Sends access_token in every request:
│  Authorization: Bearer eyJ...
└──────────────┘
```

**Token lifetimes:**
- `access_token` — 15 minutes (short, for security)
- `refresh_token` — 7 days (Flutter calls `/auth/refresh` silently when access expires)

**Password storage:** Passwords are **never stored as plain text**. `bcrypt.hash(password, 10)` creates a one-way hash. `bcrypt.compare` checks it without decrypting.

---

## 7. Exact JSON Shapes Flutter Expects

Your Flutter app (`auth_remote_datasource.dart`) reads exactly this structure:

### Login / Register Response
```json
{
  "data": {
    "user": {
      "id": "uuid-string",
      "fullName": "Dev User",
      "email": "user@gmail.com",
      "phone": "0712345678",
      "role": "user",
      "avatarUrl": null,
      "isVerified": true,
      "createdAt": "2026-03-02T10:00:00.000Z"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

> **Important:** The field names must be camelCase exactly as shown above (`fullName`, `avatarUrl`, `isVerified`, `createdAt`) because that is what `user_model.g.dart` maps to.

---

## 8. Wire Flutter to the Server

### Step 1 — Change the base URL

In `lib/core/network/api_endpoints.dart`:

```dart
// BEFORE (your physical machine IP — doesn't work in emulator):
static const String baseUrl = 'http://192.168.1.100:3000/api/v1';

// AFTER (10.0.2.2 is the Android emulator's alias for your PC's localhost):
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

> For iOS Simulator use `http://localhost:3000/api/v1`
> For a real physical device use your PC's actual LAN IP (`192.168.1.x`)

### Step 2 — Remove the dev bypass

In `lib/features/auth/presentation/viewmodels/auth_viewmodel.dart`, remove this block:

```dart
// ── DEV BYPASS: skip API when no backend is running ──
if (email == 'user@gmail.com' && password == '123456') {
  state = AsyncData(UserEntity(
    id: 'dev-user-001',
    ...
  ));
  return null;
}
// ── END DEV BYPASS ──────────────────────────────────
```

### Step 3 — Update `android/app/src/main/AndroidManifest.xml`

Add internet and cleartext permission (for local HTTP during dev):

```xml
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:usesCleartextTraffic="true"   <!-- add this for HTTP on emulator -->
        ...>
```

---

## 9. Run & Test

### Start the server
```bash
cd visaduma-backend
npm run dev
# ✅ VisaDuma API running at http://localhost:3000
```

### Test with curl
```bash
# Register
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"full_name":"Test User","email":"test@test.com","phone":"0711234567","password":"123456","role":"user"}'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@gmail.com","password":"123456"}'
```

### Run Flutter
```bash
cd G:\personal-projects\visaduma
flutter run
```

Tap **Log In** with `user@gmail.com` / `123456` — it now hits MySQL and returns a real JWT.

---

## Summary Checklist

- [ ] MySQL installed and `visaduma` database created
- [ ] `visaduma-backend` folder created with all files above
- [ ] `.env` filled in with your MySQL root password
- [ ] `npm run dev` running — no errors in console
- [ ] `api_endpoints.dart` baseUrl changed to `http://10.0.2.2:3000/api/v1`
- [ ] Dev bypass block removed from `auth_viewmodel.dart`
- [ ] `AndroidManifest.xml` has `usesCleartextTraffic="true"`
- [ ] `flutter run` — login works end-to-end
