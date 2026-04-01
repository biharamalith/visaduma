const express = require('express');
const http = require('http');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const uploadRoutes = require('./routes/upload');
const errorHandler = require('./middleware/errorHandler');
const { checkDatabaseHealth } = require('./config/database');
const { initializeRedis, checkRedisHealth } = require('./config/redis');
const { validateS3Config } = require('./config/s3');
const { initializeSocketIO } = require('./config/socket');
const { setupSocketHandlers } = require('./services/socketService');

const app = express();
const httpServer = http.createServer(app);

// Initialize Redis connection
initializeRedis();

// Validate S3 configuration
validateS3Config();

// Initialize Socket.IO
initializeSocketIO(httpServer);
setupSocketHandlers();

// Security middleware
app.use(helmet());
app.use(cors());

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: 'Too many requests from this IP, please try again later.',
});
app.use('/api/', limiter);

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// Database health check endpoint
app.get('/health/db', async (req, res) => {
  try {
    const dbHealth = await checkDatabaseHealth();
    const statusCode = dbHealth.status === 'healthy' ? 200 : 503;
    res.status(statusCode).json(dbHealth);
  } catch (err) {
    res.status(503).json({
      status: 'unhealthy',
      error: err.message,
      timestamp: new Date().toISOString(),
    });
  }
});

// Redis health check endpoint
app.get('/health/redis', async (req, res) => {
  try {
    const redisHealth = await checkRedisHealth();
    const statusCode = redisHealth.status === 'healthy' ? 200 : 503;
    res.status(statusCode).json(redisHealth);
  } catch (err) {
    res.status(503).json({
      status: 'unhealthy',
      error: err.message,
      timestamp: new Date().toISOString(),
    });
  }
});

// API routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/upload', uploadRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ 
    success: false, 
    message: 'Route not found.' 
  });
});

// Error handling middleware
app.use(errorHandler);

// Start server
const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`✅ VisaDuma API running at http://localhost:${PORT}`);
  console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔌 Socket.IO server ready for WebSocket connections`);
});
