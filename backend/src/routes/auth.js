const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { pool } = require('../config/database');
const { requireAuth } = require('../middleware/auth');
const { formatUser } = require('../utils/formatters');
const { signAccessToken, signRefreshToken } = require('../utils/jwt');

const router = express.Router();

/**
 * Save refresh token to database
 */
async function saveRefreshToken(userId, token) {
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days
  await pool.query(
    'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES ($1, $2, $3)',
    [userId, token, expiresAt]
  );
}

/**
 * POST /api/v1/auth/register
 * Register a new user
 */
router.post('/register', async (req, res, next) => {
  try {
    const { full_name, email, phone, password, role } = req.body;

    if (!full_name || !email || !password) {
      return res.status(422).json({ 
        success: false, 
        message: 'full_name, email and password are required.' 
      });
    }

    // Check if email already exists
    const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
    if (existing.rows.length > 0) {
      return res.status(422).json({ 
        success: false, 
        message: 'Email already in use.' 
      });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // Insert user
    const result = await pool.query(
      'INSERT INTO users (full_name, email, phone, password_hash, role) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [full_name, email, phone || '', passwordHash, role || 'user']
    );
    const user = result.rows[0];

    // Generate tokens
    const accessToken = signAccessToken(user.id, user.role);
    const refreshToken = signRefreshToken(user.id);
    await saveRefreshToken(user.id, refreshToken);

    return res.status(201).json({
      success: true,
      data: {
        user: formatUser(user),
        access_token: accessToken,
        refresh_token: refreshToken,
      },
    });
  } catch (error) {
    next(error);
  }
});

/**
 * POST /api/v1/auth/login
 * Login user
 */
router.post('/login', async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(422).json({ 
        success: false, 
        message: 'Email and password are required.' 
      });
    }

    // Find user
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    const user = result.rows[0];

    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid email or password.' 
      });
    }

    // Generate tokens
    const accessToken = signAccessToken(user.id, user.role);
    const refreshToken = signRefreshToken(user.id);
    await saveRefreshToken(user.id, refreshToken);

    return res.json({
      success: true,
      data: {
        user: formatUser(user),
        access_token: accessToken,
        refresh_token: refreshToken,
      },
    });
  } catch (error) {
    next(error);
  }
});

/**
 * POST /api/v1/auth/logout
 * Logout user
 */
router.post('/logout', requireAuth, async (req, res, next) => {
  try {
    // Delete all refresh tokens for this user
    await pool.query('DELETE FROM refresh_tokens WHERE user_id = $1', [req.user.id]);
    
    return res.json({ 
      success: true, 
      message: 'Logged out successfully.' 
    });
  } catch (error) {
    next(error);
  }
});

/**
 * POST /api/v1/auth/refresh
 * Refresh access token
 */
router.post('/refresh', async (req, res, next) => {
  try {
    const { refresh_token } = req.body;
    
    if (!refresh_token) {
      return res.status(401).json({ 
        success: false, 
        message: 'Refresh token missing.' 
      });
    }

    // Verify token
    const payload = jwt.verify(refresh_token, process.env.JWT_SECRET);
    
    // Check if token exists in database
    const result = await pool.query(
      'SELECT * FROM refresh_tokens WHERE user_id = $1 AND token = $2 AND expires_at > NOW()',
      [payload.id, refresh_token]
    );
    
    if (result.rows.length === 0) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid or expired refresh token.' 
      });
    }

    // Get user role
    const userResult = await pool.query('SELECT role FROM users WHERE id = $1', [payload.id]);
    const userRole = userResult.rows[0]?.role || 'user';

    // Generate new access token
    const newAccessToken = signAccessToken(payload.id, userRole);
    
    return res.json({ 
      success: true, 
      data: { access_token: newAccessToken } 
    });
  } catch (error) {
    return res.status(401).json({ 
      success: false, 
      message: 'Invalid refresh token.' 
    });
  }
});

/**
 * GET /api/v1/auth/me
 * Get current user
 */
router.get('/me', requireAuth, async (req, res, next) => {
  try {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [req.user.id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found.' 
      });
    }
    
    return res.json({ 
      success: true, 
      data: { user: formatUser(result.rows[0]) } 
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
