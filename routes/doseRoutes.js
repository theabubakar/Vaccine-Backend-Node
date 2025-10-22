const express = require('express');
const router = express.Router();
const Dose = require('../models/Dose');
const Vaccine = require('../models/Vaccine');

/**
 * @swagger
 * components:
 *   schemas:
 *     Dose:
 *       type: object
 *       required:
 *         - minAge
 *         - maxAge
 *         - vaccineID
 *       properties:
 *         doseId:
 *           type: number
 *           description: Auto-generated unique identifier for the dose
 *           example: 1
 *         name:
 *           type: string
 *           description: Name of the dose (optional)
 *           example: First Dose
 *         minAge:
 *           type: number
 *           description: Minimum age for this dose
 *           example: 18
 *         maxAge:
 *           type: number
 *           description: Maximum age for this dose
 *           example: 100
 *         minGap:
 *           type: number
 *           description: Minimum gap between doses in days
 *           default: 0
 *           example: 28
 *         vaccineID:
 *           type: string
 *           description: Reference to Vaccine collection
 *           example: VAC001
 *         vaccine:
 *           $ref: '#/components/schemas/Vaccine'
 *           description: Populated vaccine information
 */

/**
 * @swagger
 * /api/doses:
 *   get:
 *     summary: Get all doses
 *     tags: [Doses]
 *     responses:
 *       200:
 *         description: List of all doses
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
 *                   example: 3
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Dose'
 *       500:
 *         description: Server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/', async (req, res) => {
  try {
    const doses = await Dose.find().populate('vaccineID', 'name vaccineID').sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      count: doses.length,
      data: doses
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching doses',
      error: error.message
    });
  }
});

// GET dose by ID
router.get('/:id', async (req, res) => {
  try {
    const dose = await Dose.findOne({ doseId: req.params.id }).populate('vaccineID', 'name vaccineID');
    
    if (!dose) {
      return res.status(404).json({
        success: false,
        message: 'Dose not found'
      });
    }

    res.status(200).json({
      success: true,
      data: dose
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching dose',
      error: error.message
    });
  }
});

// GET doses by vaccine ID
router.get('/vaccine/:vaccineId', async (req, res) => {
  try {
    const doses = await Dose.find({ vaccineID: req.params.vaccineId }).populate('vaccineID', 'name vaccineID');
    
    res.status(200).json({
      success: true,
      count: doses.length,
      data: doses
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching doses for vaccine',
      error: error.message
    });
  }
});

/**
 * @swagger
 * /api/doses:
 *   post:
 *     summary: Create a new dose
 *     tags: [Doses]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Dose'
 *           example:
 *             name: First Dose
 *             minAge: 18
 *             maxAge: 100
 *             minGap: 28
 *             vaccineID: 507f1f77bcf86cd799439011
 *     responses:
 *       201:
 *         description: Dose created successfully
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
 *                   example: Dose created successfully
 *                 data:
 *                   $ref: '#/components/schemas/Dose'
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
    const { name, minAge, maxAge, minGap, vaccineID } = req.body;

    // Validate required fields
    if (minAge === undefined || maxAge === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Please provide minAge and maxAge'
      });
    }

    // Verify that vaccineID exists (only if provided)
    if (vaccineID) {
      const vaccine = await Vaccine.findById(vaccineID);
      if (!vaccine) {
        return res.status(400).json({
          success: false,
          message: 'Vaccine with this ID does not exist'
        });
      }
    }

    const dose = new Dose({
      name,
      minAge,
      maxAge,
      minGap: minGap || 0,
      vaccineID
    });

    const savedDose = await dose.save();
    if (savedDose.vaccineID) {
      await savedDose.populate('vaccineID', 'name vaccineID');
    }

    res.status(201).json({
      success: true,
      message: 'Dose created successfully',
      data: savedDose
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating dose',
      error: error.message
    });
  }
});

// PUT update dose
router.put('/:id', async (req, res) => {
  try {
    const { name, minAge, maxAge, minGap, vaccineID } = req.body;

    const dose = await Dose.findById(req.params.id);
    
    if (!dose) {
      return res.status(404).json({
        success: false,
        message: 'Dose not found'
      });
    }

    // If vaccineID is being updated, verify it exists
    if (vaccineID && vaccineID !== dose.vaccineID.toString()) {
      const vaccine = await Vaccine.findById(vaccineID);
      if (!vaccine) {
        return res.status(400).json({
          success: false,
          message: 'Vaccine with this ID does not exist'
        });
      }
    }

    // Update fields if provided
    if (name !== undefined) dose.name = name;
    if (minAge !== undefined) dose.minAge = minAge;
    if (maxAge !== undefined) dose.maxAge = maxAge;
    if (minGap !== undefined) dose.minGap = minGap;
    if (vaccineID !== undefined) dose.vaccineID = vaccineID;

    const updatedDose = await dose.save();
    await updatedDose.populate('vaccineID', 'name vaccineID');

    res.status(200).json({
      success: true,
      message: 'Dose updated successfully',
      data: updatedDose
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating dose',
      error: error.message
    });
  }
});

// DELETE dose
router.delete('/:id', async (req, res) => {
  try {
    const dose = await Dose.findByIdAndDelete(req.params.id);
    
    if (!dose) {
      return res.status(404).json({
        success: false,
        message: 'Dose not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Dose deleted successfully',
      data: dose
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting dose',
      error: error.message
    });
  }
});

module.exports = router;
