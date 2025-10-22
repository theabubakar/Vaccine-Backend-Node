const mongoose = require('mongoose');

const doseSchema = new mongoose.Schema({
  doseId: {
    type: Number,
    unique: true
  },
  name: {
    type: String,
    required: false,
    trim: true
  },
  minAge: {
    type: Number,
    required: true,
    min: 0
  },
  maxAge: {
    type: Number,
    required: true,
    min: 0
  },
  minGap: {
    type: Number,
    required: true,
    min: 0,
    default: 0
  },
  vaccineID: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Vaccine',
    required: false // Changed to false to handle existing null values
  }
}, {
  timestamps: true
});

// Create indexes for better performance
doseSchema.index({ doseId: 1 });
doseSchema.index({ vaccineID: 1 });

// Auto-increment doseId before saving
doseSchema.pre('save', async function(next) {
  if (this.isNew && !this.doseId) {
    try {
      // Find the highest existing doseId and increment it
      const lastDose = await this.constructor.findOne({}, {}, { sort: { 'doseId': -1 } });
      this.doseId = lastDose ? lastDose.doseId + 1 : 1;
    } catch (error) {
      return next(error);
    }
  }
  next();
});

// Validate that vaccineID exists in Vaccine collection (only if provided)
doseSchema.pre('save', async function(next) {
  try {
    if (this.vaccineID) {
      const Vaccine = mongoose.model('Vaccine');
      const vaccine = await Vaccine.findById(this.vaccineID);
      if (!vaccine) {
        throw new Error('Vaccine with this ID does not exist');
      }
    }
    next();
  } catch (error) {
    next(error);
  }
});

module.exports = mongoose.model('Dose', doseSchema);
