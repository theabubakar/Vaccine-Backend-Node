const mongoose = require('mongoose');

const vaccineSchema = new mongoose.Schema({
  vaccineID: {
    type: Number,
    unique: true
  },
  name: {
    type: String,
    required: true,
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
  isInfinite: {
    type: Boolean,
    default: false
  },
  validity: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Create index on vaccineID for faster queries
vaccineSchema.index({ vaccineID: 1 });

// Auto-increment vaccineID before saving
vaccineSchema.pre('save', async function(next) {
  if (this.isNew && !this.vaccineID) {
    try {
      // Find the highest existing vaccineID and increment it
      const lastVaccine = await this.constructor.findOne({}, {}, { sort: { 'vaccineID': -1 } });
      this.vaccineID = lastVaccine ? lastVaccine.vaccineID + 1 : 1;
    } catch (error) {
      return next(error);
    }
  }
  next();
});

module.exports = mongoose.model('Vaccine', vaccineSchema);
