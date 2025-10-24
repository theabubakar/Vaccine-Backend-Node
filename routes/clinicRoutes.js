const express = require('express');
const router = express.Router();
const Clinic = require('../models/Clinic');
const Doctor = require('../models/Doctor');

/**
 * @swagger
 * tags:
 *   name: Clinics
 *   description: Clinic management
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     Clinic:
 *       type: object
 *       required:
 *         - name
 *         - address
 *         - regNo
 *         - phoneNumber
 *         - clinicFee
 *         - doctor
 *       properties:
 *         _id:
 *           type: string
 *           description: MongoDB ObjectId
 *         clinicId:
 *           type: number
 *           description: Auto-generated sequential ID
 *         name:
 *           type: string
 *           description: Clinic name
 *         address:
 *           type: string
 *           description: Clinic address
 *         regNo:
 *           type: string
 *           description: Registration number
 *         logo:
 *           type: string
 *           description: Clinic logo URL or base64
 *         phoneNumber:
 *           type: string
 *           description: Clinic phone number
 *         clinicFee:
 *           type: number
 *           description: Consultation fee
 *         doctor:
 *           type: string
 *           description: Doctor ObjectId
 *         isActive:
 *           type: boolean
 *           description: Clinic status
 */

/**
 * @swagger
 * /api/clinics:
 *   get:
 *     summary: Get all clinics
 *     tags: [Clinics]
 *     responses:
 *       200:
 *         description: List of all clinics
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 count:
 *                   type: number
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Clinic'
 */
router.get('/', async (req, res) => {
  try {
    const clinics = await Clinic.find({ isActive: true })
      .populate('doctor', 'firstName lastName email mobileNumber')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: clinics.length,
      data: clinics
    });
  } catch (error) {
    console.error('Get clinics error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/clinics/doctor/{doctorId}:
 *   get:
 *     summary: Get all clinics by doctor ID
 *     tags: [Clinics]
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         required: true
 *         schema:
 *           type: string
 *         description: Doctor ObjectId
 *     responses:
 *       200:
 *         description: Clinics found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 count:
 *                   type: number
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Clinic'
 */
router.get('/doctor/:doctorId', async (req, res) => {
  try {
    const { doctorId } = req.params;

    const clinics = await Clinic.find({ 
      doctor: doctorId, 
      isActive: true 
    }).populate('doctor', 'firstName lastName email mobileNumber').sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: clinics.length,
      data: clinics
    });
  } catch (error) {
    console.error('Get clinics by doctor error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/clinics:
 *   post:
 *     summary: Create a new clinic
 *     tags: [Clinics]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - address
 *               - regNo
 *               - phoneNumber
 *               - clinicFee
 *               - doctor
 *             properties:
 *               name:
 *                 type: string
 *                 example: "City Medical Center"
 *               address:
 *                 type: string
 *                 example: "123 Main Street, City, State"
 *               regNo:
 *                 type: string
 *                 example: "REG123456"
 *               logo:
 *                 type: string
 *                 example: "data:image/jpeg;base64,..."
 *               phoneNumber:
 *                 type: string
 *                 example: "+1234567890"
 *               clinicFee:
 *                 type: number
 *                 example: 100
 *               doctor:
 *                 type: string
 *                 example: "507f1f77bcf86cd799439011"
 *     responses:
 *       201:
 *         description: Clinic created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Clinic'
 *       400:
 *         description: Bad request
 *       409:
 *         description: Doctor already has a clinic
 */
router.post('/', async (req, res) => {
  try {
    const { name, address, regNo, logo, phoneNumber, clinicFee, doctor } = req.body;

    // Validate required fields
    if (!name || !address || !regNo || !phoneNumber || !clinicFee || !doctor) {
      return res.status(400).json({
        success: false,
        message: 'Please provide all required fields: name, address, regNo, phoneNumber, clinicFee, doctor'
      });
    }

    // Check if doctor exists
    const doctorExists = await Doctor.findById(doctor);
    if (!doctorExists) {
      return res.status(400).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    // Allow multiple clinics per doctor - removed constraint

    // Check if registration number already exists
    const existingRegNo = await Clinic.findOne({ regNo, isActive: true });
    if (existingRegNo) {
      return res.status(400).json({
        success: false,
        message: 'Registration number already exists'
      });
    }

    const clinic = new Clinic({
      name: name.trim(),
      address: address.trim(),
      regNo: regNo.trim(),
      logo: logo || '',
      phoneNumber: phoneNumber.trim(),
      clinicFee: parseFloat(clinicFee),
      doctor
    });

    const savedClinic = await clinic.save();
    await savedClinic.populate('doctor', 'firstName lastName email mobileNumber');

    res.status(201).json({
      success: true,
      message: 'Clinic created successfully',
      data: savedClinic
    });
  } catch (error) {
    console.error('Create clinic error:', error);
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Registration number already exists'
      });
    }
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/clinics/{id}:
 *   put:
 *     summary: Update clinic
 *     tags: [Clinics]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Clinic ObjectId
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               address:
 *                 type: string
 *               regNo:
 *                 type: string
 *               logo:
 *                 type: string
 *               phoneNumber:
 *                 type: string
 *               clinicFee:
 *                 type: number
 *     responses:
 *       200:
 *         description: Clinic updated successfully
 *       404:
 *         description: Clinic not found
 */
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Remove doctor field from update data (can't change doctor)
    delete updateData.doctor;

    const clinic = await Clinic.findByIdAndUpdate(
      id,
      { ...updateData, updatedAt: new Date() },
      { new: true, runValidators: true }
    ).populate('doctor', 'firstName lastName email mobileNumber');

    if (!clinic) {
      return res.status(404).json({
        success: false,
        message: 'Clinic not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Clinic updated successfully',
      data: clinic
    });
  } catch (error) {
    console.error('Update clinic error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/clinics/{id}:
 *   delete:
 *     summary: Delete clinic (soft delete)
 *     tags: [Clinics]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Clinic ObjectId
 *     responses:
 *       200:
 *         description: Clinic deleted successfully
 *       404:
 *         description: Clinic not found
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const clinic = await Clinic.findByIdAndUpdate(
      id,
      { isActive: false, updatedAt: new Date() },
      { new: true }
    );

    if (!clinic) {
      return res.status(404).json({
        success: false,
        message: 'Clinic not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Clinic deleted successfully'
    });
  } catch (error) {
    console.error('Delete clinic error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

module.exports = router;
