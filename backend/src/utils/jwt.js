const jwt = require('jsonwebtoken');

/**
 * Generate JWT access token
 */
function signAccessToken(userId, role) {
  return jwt.sign(
    { id: userId, role: role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );
}

/**
 * Generate JWT refresh token
 */
function signRefreshToken(userId) {
  return jwt.sign(
    { id: userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN }
  );
}

module.exports = {
  signAccessToken,
  signRefreshToken,
};
