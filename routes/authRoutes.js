const express = require('express');
const router = express.Router();
const Doctor = require('../models/Doctor');
const jwt = require('jsonwebtoken');

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Doctor authentication management
 */

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     summary: Doctor login
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - identifier
 *               - password
 *             properties:
 *               identifier:
 *                 type: string
 *                 description: Doctor's email or mobile number
 *                 example: "doctor@example.com"
 *               password:
 *                 type: string
 *                 description: Doctor's password
 *                 example: "test123"
 *     responses:
 *       200:
 *         description: Login successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 token:
 *                   type: string
 *                   example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
 *                 doctor:
 *                   $ref: '#/components/schemas/Doctor'
 *       400:
 *         description: Invalid credentials
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: Invalid credentials
 *       500:
 *         description: Server error
 */
router.post('/login', async (req, res) => {
  const { identifier, password } = req.body;

  try {
    // Find doctor by email or mobile number
    const doctor = await Doctor.findOne({
      $or: [{ email: identifier }, { mobileNumber: identifier }]
    });

    if (!doctor) {
      return res.status(400).json({ success: false, message: 'Invalid credentials' });
    }

    // Compare password (plain text as per user request)
    if (doctor.password !== password) {
      return res.status(400).json({ success: false, message: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: doctor._id, doctorId: doctor.doctorId, email: doctor.email },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '1h' }
    );

    res.status(200).json({ success: true, token, doctor });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});

/**
 * @swagger
 * /api/auth/verify:
 *   post:
 *     summary: Verify doctor token
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Token is valid
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 doctor:
 *                   $ref: '#/components/schemas/Doctor'
 *       401:
 *         description: Unauthorized - Invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: Unauthorized
 *       500:
 *         description: Server error
 */
router.post('/verify', async (req, res) => {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ success: false, message: 'Unauthorized: No token provided' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
    const doctor = await Doctor.findById(decoded.id).select('-password'); // Exclude password

    if (!doctor) {
      return res.status(401).json({ success: false, message: 'Unauthorized: Doctor not found' });
    }

    res.status(200).json({ success: true, doctor });
  } catch (error) {
    console.error('Token verification error:', error);
    res.status(401).json({ success: false, message: 'Unauthorized: Invalid token', error: error.message });
  }
});

module.exports = router;
