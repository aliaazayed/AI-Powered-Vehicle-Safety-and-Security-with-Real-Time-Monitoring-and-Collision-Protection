const mongoose = require('mongoose');

const deviceSchema = new mongoose.Schema({
  raspberryModel: {
    type: String,
    required: true
  },
  espType: {
    type: String,
    required: true
  },
  registeredAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Device', deviceSchema);
