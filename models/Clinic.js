const mongoose = require('mongoose');

const clinicSchema = new mongoose.Schema({
  clinicId: {
    type: Number,
    unique: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  address: {
    type: String,
    required: true,
    trim: true
  },
  regNo: {
    type: String,
    required: true,
    trim: true,
    unique: true
  },
  logo: {
    type: String,
    default: ''
  },
  phoneNumber: {
    type: String,
    required: true,
    trim: true
  },
  clinicFee: {
    type: Number,
    required: true,
    min: 0
  },
  doctor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Doctor',
    required: true
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Create indexes for better performance
clinicSchema.index({ clinicId: 1 });
clinicSchema.index({ regNo: 1 });
clinicSchema.index({ doctor: 1 });

// Auto-increment clinicId before saving
clinicSchema.pre('save', async function(next) {
  if (this.isNew && !this.clinicId) {
    try {
      // Find the highest existing clinicId and increment it
      const lastClinic = await this.constructor.findOne({}, {}, { sort: { 'clinicId': -1 } });
      this.clinicId = lastClinic ? lastClinic.clinicId + 1 : 1;
    } catch (error) {
      return next(error);
    }
  }
  next();
});

// Index for doctor lookup (removed unique constraint to allow multiple clinics)
clinicSchema.index({ doctor: 1 });

module.exports = mongoose.model('Clinic', clinicSchema);
