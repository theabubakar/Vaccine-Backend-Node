const mongoose = require('mongoose');

const doctorSchema = new mongoose.Schema({
  doctorId: {
    type: Number,
    unique: true
  },
  firstName: {
    type: String,
    required: true,
    trim: true
  },
  lastName: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  mobileNumber: {
    type: String,
    required: true,
    trim: true
  },
  type: {
    type: String,
    trim: true,
    default: ''
  },
  qualifications: {
    type: String,
    trim: true,
    default: ''
  },
  additionalInfo: {
    type: String,
    trim: true,
    default: ''
  },
  password: {
    type: String,
    required: true
  },
  image: {
    type: String,
    default: ''
  },
  pmdc: {
    type: String,
    trim: true,
    default: ''
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Create indexes for better performance
doctorSchema.index({ doctorId: 1 });
doctorSchema.index({ email: 1 });

// Auto-increment doctorId before saving
doctorSchema.pre('save', async function(next) {
  if (this.isNew && !this.doctorId) {
    try {
      // Find the highest existing doctorId and increment it
      const lastDoctor = await this.constructor.findOne({}, {}, { sort: { 'doctorId': -1 } });
      this.doctorId = lastDoctor ? lastDoctor.doctorId + 1 : 1;
    } catch (error) {
      return next(error);
    }
  }
  next();
});

// Simple password storage (no hashing)

// Method to get full name
doctorSchema.virtual('fullName').get(function() {
  return `${this.firstName} ${this.lastName}`;
});

module.exports = mongoose.model('Doctor', doctorSchema);
