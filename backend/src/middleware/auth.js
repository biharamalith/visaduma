const jwt = require('jsonwebtoken');

/**
 * Middleware to verify JWT token and authenticate requests
 */
function requireAuth(req, res, next) {
  const header = req.headers.authorization;
  
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ 
      success: false, 
      message: 'Unauthorized. Token missing.' 
    });
  }
  
  const token = header.split(' ')[1];
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ 
      success: false, 
      message: 'Token expired or invalid.' 
    });
  }
}

/**
 * Middleware to check if user has required role
 */
function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Unauthorized.' 
      });
    }
    
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ 
        success: false, 
        message: 'Forbidden. Insufficient permissions.' 
      });
    }
    
    next();
  };
}

module.exports = { requireAuth, requireRole };
