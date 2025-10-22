const mongoose = require('mongoose');

const brandSchema = new mongoose.Schema({
  brandId: {
    type: Number,
    unique: true
  },
  name: {
    type: String,
    required: true,
    trim: true,
    unique: true
  }
}, {
  timestamps: true
});

// Create index on brandId for faster queries
brandSchema.index({ brandId: 1 });

// Auto-increment brandId before saving
brandSchema.pre('save', async function(next) {
  if (this.isNew && !this.brandId) {
    try {
      // Find the highest existing brandId and increment it
      const lastBrand = await this.constructor.findOne({}, {}, { sort: { 'brandId': -1 } });
      this.brandId = lastBrand ? lastBrand.brandId + 1 : 1;
    } catch (error) {
      return next(error);
    }
  }
  next();
});

module.exports = mongoose.model('Brand', brandSchema);
