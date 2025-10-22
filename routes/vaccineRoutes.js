const express = require('express');
const router = express.Router();
const Vaccine = require('../models/Vaccine');

/**
 * @swagger
 * components:
 *   schemas:
 *     Vaccine:
 *       type: object
 *       required:
 *         - name
 *         - minAge
 *         - maxAge
 *       properties:
 *         vaccineID:
 *           type: number
 *           description: Auto-generated unique identifier for the vaccine
 *           example: 1
 *         name:
 *           type: string
 *           description: Name of the vaccine
 *           example: COVID-19 Vaccine
 *         minAge:
 *           type: number
 *           description: Minimum age for vaccination
 *           example: 18
 *         maxAge:
 *           type: number
 *           description: Maximum age for vaccination
 *           example: 100
 *         isInfinite:
 *           type: boolean
 *           description: Whether the vaccine has infinite validity
 *           default: false
 *         validity:
 *           type: boolean
 *           description: Current validity status
 *           default: true
 */

/**
 * @swagger
 * /api/vaccines:
 *   get:
 *     summary: Get all vaccines
 *     tags: [Vaccines]
 *     responses:
 *       200:
 *         description: List of all vaccines
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
 *                     $ref: '#/components/schemas/Vaccine'
 *       500:
 *         description: Server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/', async (req, res) => {
  try {
    const vaccines = await Vaccine.find().sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      count: vaccines.length,
      data: vaccines
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching vaccines',
      error: error.message
    });
  }
});

// GET vaccine by ID
router.get('/:id', async (req, res) => {
  try {
    const vaccine = await Vaccine.findOne({ vaccineID: req.params.id });
    
    if (!vaccine) {
      return res.status(404).json({
        success: false,
        message: 'Vaccine not found'
      });
    }

    res.status(200).json({
      success: true,
      data: vaccine
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching vaccine',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/vaccines:
 *   post:
 *     summary: Create a new vaccine
 *     tags: [Vaccines]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Vaccine'
 *           example:
 *             name: COVID-19 Vaccine
 *             minAge: 18
 *             maxAge: 100
 *             isInfinite: false
 *             validity: true
 *     responses:
 *       201:
 *         description: Vaccine created successfully
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
 *                   example: Vaccine created successfully
 *                 data:
 *                   $ref: '#/components/schemas/Vaccine'
 *       400:
 *         description: Bad request - validation error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/', async (req, res) => {
  try {
    const { name, minAge, maxAge, isInfinite, validity } = req.body;

    // Validate required fields
    if (!name || minAge === undefined || maxAge === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Please provide name, minAge, and maxAge'
      });
    }

    const vaccine = new Vaccine({
      name,
      minAge,
      maxAge,
      isInfinite: isInfinite || false,
      validity: validity !== undefined ? validity : true
    });

    const savedVaccine = await vaccine.save();

    res.status(201).json({
      success: true,
      message: 'Vaccine created successfully',
      data: savedVaccine
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating vaccine',
      error: error.message
    });
  }
});

// PUT update vaccine
router.put('/:id', async (req, res) => {
  try {
    const { name, minAge, maxAge, isInfinite, validity } = req.body;

    const vaccine = await Vaccine.findById(req.params.id);
    
    if (!vaccine) {
      return res.status(404).json({
        success: false,
        message: 'Vaccine not found'
      });
    }

    // Update fields if provided
    if (name !== undefined) vaccine.name = name;
    if (minAge !== undefined) vaccine.minAge = minAge;
    if (maxAge !== undefined) vaccine.maxAge = maxAge;
    if (isInfinite !== undefined) vaccine.isInfinite = isInfinite;
    if (validity !== undefined) vaccine.validity = validity;

    const updatedVaccine = await vaccine.save();

    res.status(200).json({
      success: true,
      message: 'Vaccine updated successfully',
      data: updatedVaccine
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating vaccine',
      error: error.message
    });
  }
});

// DELETE vaccine
router.delete('/:id', async (req, res) => {
  try {
    const vaccine = await Vaccine.findByIdAndDelete(req.params.id);
    
    if (!vaccine) {
      return res.status(404).json({
        success: false,
        message: 'Vaccine not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Vaccine deleted successfully',
      data: vaccine
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting vaccine',
      error: error.message
    });
  }
});

module.exports = router;
