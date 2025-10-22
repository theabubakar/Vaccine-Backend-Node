const express = require('express');
const router = express.Router();
const Doctor = require('../models/Doctor');
const crypto = require('crypto');

// Function to generate a secure password
function generatePassword() {
  const length = 12;
  const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
  let password = '';
  
  // Ensure at least one character from each category
  password += 'abcdefghijklmnopqrstuvwxyz'[Math.floor(Math.random() * 26)]; // lowercase
  password += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[Math.floor(Math.random() * 26)]; // uppercase
  password += '0123456789'[Math.floor(Math.random() * 10)]; // number
  password += '!@#$%^&*'[Math.floor(Math.random() * 8)]; // special char
  
  // Fill the rest randomly
  for (let i = 4; i < length; i++) {
    password += charset[Math.floor(Math.random() * charset.length)];
  }
  
  // Shuffle the password
  return password.split('').sort(() => Math.random() - 0.5).join('');
}

/**
 * @swagger
 * components:
 *   schemas:
 *     Doctor:
 *       type: object
 *       required:
 *         - firstName
 *         - lastName
 *         - email
 *         - mobileNumber
 *       properties:
 *         _id:
 *           type: string
 *           description: MongoDB ObjectId
 *           example: 507f1f77bcf86cd799439011
 *         doctorId:
 *           type: number
 *           description: Auto-generated sequential ID
 *           example: 1
 *         firstName:
 *           type: string
 *           description: Doctor's first name
 *           example: John
 *         lastName:
 *           type: string
 *           description: Doctor's last name
 *           example: Doe
 *         email:
 *           type: string
 *           description: Doctor's email address
 *           example: john.doe@example.com
 *         mobileNumber:
 *           type: string
 *           description: Doctor's mobile number
 *           example: +1234567890
 *         type:
 *           type: string
 *           description: Doctor's type/specialization
 *           example: Cardiologist
 *         qualifications:
 *           type: string
 *           description: Doctor's qualifications
 *           example: MBBS, MD
 *         additionalInfo:
 *           type: string
 *           description: Additional information about the doctor
 *           example: 10 years experience
 *         password:
 *           type: string
 *           description: Encrypted password
 *         image:
 *           type: string
 *           description: Doctor's profile image URL
 *           example: https://example.com/image.jpg
 *         pmdc:
 *           type: string
 *           description: PMDC registration number
 *           example: PMDC-12345
 *         isActive:
 *           type: boolean
 *           description: Whether the doctor is active
 *           example: true
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Creation timestamp
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Last update timestamp
 */

/**
 * @swagger
 * /api/doctors:
 *   get:
 *     summary: Get all doctors
 *     tags: [Doctors]
 *     responses:
 *       200:
 *         description: List of all doctors
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 count:
 *                   type: number
 *                   example: 5
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Doctor'
 */

// GET all doctors
router.get('/', async (req, res) => {
  try {
    const doctors = await Doctor.find().select('-password').sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      count: doctors.length,
      data: doctors
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching doctors',
      error: error.message
    });
  }
});

// GET doctor by ID
router.get('/:id', async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id).select('-password');
    
    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    res.status(200).json({
      success: true,
      data: doctor
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching doctor',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/doctors:
 *   post:
 *     summary: Create a new doctor
 *     tags: [Doctors]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - firstName
 *               - lastName
 *               - email
 *               - mobileNumber
 *             properties:
 *               firstName:
 *                 type: string
 *                 description: Doctor's first name
 *                 example: John
 *               lastName:
 *                 type: string
 *                 description: Doctor's last name
 *                 example: Doe
 *               email:
 *                 type: string
 *                 description: Doctor's email address
 *                 example: john.doe@example.com
 *               mobileNumber:
 *                 type: string
 *                 description: Doctor's mobile number
 *                 example: +1234567890
 *     responses:
 *       201:
 *         description: Doctor created successfully
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
 *                   example: Doctor created successfully
 *                 data:
 *                   $ref: '#/components/schemas/Doctor'
 *                 generatedPassword:
 *                   type: string
 *                   example: Abc123!@#
 *       400:
 *         description: Bad request
 *       500:
 *         description: Server error
 */

// POST create new doctor
router.post('/', async (req, res) => {
  try {
    const { firstName, lastName, email, mobileNumber } = req.body;

    // Validate required fields
    if (!firstName || !lastName || !email || !mobileNumber) {
      return res.status(400).json({
        success: false,
        message: 'Please provide firstName, lastName, email, and mobileNumber'
      });
    }

    // Check if email already exists
    const existingDoctor = await Doctor.findOne({ email });
    if (existingDoctor) {
      return res.status(400).json({
        success: false,
        message: 'Doctor with this email already exists'
      });
    }

    // Generate secure password
    const generatedPassword = generatePassword();

    const doctor = new Doctor({
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim().toLowerCase(),
      mobileNumber: mobileNumber.trim(),
      password: generatedPassword
    });

    const savedDoctor = await doctor.save();
    
    // Remove password from response
    const doctorResponse = savedDoctor.toObject();
    delete doctorResponse.password;

    res.status(201).json({
      success: true,
      message: 'Doctor created successfully',
      data: doctorResponse,
      generatedPassword: generatedPassword
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Doctor with this email already exists'
      });
    }
    res.status(500).json({
      success: false,
      message: 'Error creating doctor',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/doctors/{id}:
 *   put:
 *     summary: Update a doctor
 *     tags: [Doctors]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Doctor ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               firstName:
 *                 type: string
 *                 description: Doctor's first name
 *                 example: John
 *               lastName:
 *                 type: string
 *                 description: Doctor's last name
 *                 example: Doe
 *               email:
 *                 type: string
 *                 description: Doctor's email address
 *                 example: john.doe@example.com
 *               mobileNumber:
 *                 type: string
 *                 description: Doctor's mobile number
 *                 example: +1234567890
 *               type:
 *                 type: string
 *                 description: Doctor's type/specialization
 *                 example: Cardiologist
 *               qualifications:
 *                 type: string
 *                 description: Doctor's qualifications
 *                 example: MBBS, MD
 *               additionalInfo:
 *                 type: string
 *                 description: Additional information about the doctor
 *                 example: 10 years experience
 *               password:
 *                 type: string
 *                 description: New password (optional)
 *                 example: newpassword123
 *               image:
 *                 type: string
 *                 description: Doctor's profile image URL
 *                 example: https://example.com/image.jpg
 *               pmdc:
 *                 type: string
 *                 description: PMDC registration number
 *                 example: PMDC-12345
 *               isActive:
 *                 type: boolean
 *                 description: Whether the doctor is active
 *                 example: true
 *     responses:
 *       200:
 *         description: Doctor updated successfully
 *       404:
 *         description: Doctor not found
 *       500:
 *         description: Server error
 */

// PUT update doctor
router.put('/:id', async (req, res) => {
  try {
    const {
      firstName,
      lastName,
      email,
      mobileNumber,
      type,
      qualifications,
      additionalInfo,
      password,
      image,
      pmdc,
      isActive
    } = req.body;

    const doctor = await Doctor.findById(req.params.id);

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    // Update fields if provided
    if (firstName !== undefined) doctor.firstName = firstName.trim();
    if (lastName !== undefined) doctor.lastName = lastName.trim();
    if (email !== undefined) doctor.email = email.trim().toLowerCase();
    if (mobileNumber !== undefined) doctor.mobileNumber = mobileNumber.trim();
    if (type !== undefined) doctor.type = type.trim();
    if (qualifications !== undefined) doctor.qualifications = qualifications.trim();
    if (additionalInfo !== undefined) doctor.additionalInfo = additionalInfo.trim();
    if (password !== undefined && password.trim() !== '') doctor.password = password.trim();
    if (image !== undefined) doctor.image = image.trim();
    if (pmdc !== undefined) doctor.pmdc = pmdc.trim();
    if (isActive !== undefined) doctor.isActive = isActive;

    const updatedDoctor = await doctor.save();
    
    // Remove password from response
    const doctorResponse = updatedDoctor.toObject();
    delete doctorResponse.password;

    res.status(200).json({
      success: true,
      message: 'Doctor updated successfully',
      data: doctorResponse
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Doctor with this email already exists'
      });
    }
    res.status(500).json({
      success: false,
      message: 'Error updating doctor',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/doctors/{id}:
 *   delete:
 *     summary: Delete a doctor
 *     tags: [Doctors]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Doctor ID
 *     responses:
 *       200:
 *         description: Doctor deleted successfully
 *       404:
 *         description: Doctor not found
 *       500:
 *         description: Server error
 */

// DELETE doctor
router.delete('/:id', async (req, res) => {
  try {
    const doctor = await Doctor.findByIdAndDelete(req.params.id);

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Doctor deleted successfully',
      data: doctor
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting doctor',
      error: error.message
    });
  }
});

module.exports = router;
