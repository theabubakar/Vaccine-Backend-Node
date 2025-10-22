const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerSpecs = require('./config/swagger');
const connectDB = require('./config/database');

// Import routes
const vaccineRoutes = require('./routes/vaccineRoutes');
const doseRoutes = require('./routes/doseRoutes');

// Load environment variables
require('dotenv').config({ path: './config.env' });

// Connect to database
connectDB();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Swagger Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpecs, {
  explorer: true,
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: 'Vaccine Management API Documentation'
}));

// Routes
app.use('/api/vaccines', vaccineRoutes);
app.use('/api/doses', doseRoutes);

/**
 * @swagger
 * /api/health:
 *   get:
 *     summary: Health check endpoint
 *     tags: [System]
 *     responses:
 *       200:
 *         description: API is running successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Vaccine Management API is running
 *                 timestamp:
 *                   type: string
 *                   format: date-time
 *                   example: 2025-10-22T08:19:49.171Z
 */
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Vaccine Management API is running',
    timestamp: new Date().toISOString()
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Vaccine Management System API',
    endpoints: {
      health: '/api/health',
      vaccines: '/api/vaccines',
      doses: '/api/doses'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Something went wrong!',
    error: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/api/health`);
  console.log(`📚 API Documentation: http://localhost:${PORT}/api-docs`);
  console.log(`💉 Vaccines API: http://localhost:${PORT}/api/vaccines`);
  console.log(`💊 Doses API: http://localhost:${PORT}/api/doses`);
});
