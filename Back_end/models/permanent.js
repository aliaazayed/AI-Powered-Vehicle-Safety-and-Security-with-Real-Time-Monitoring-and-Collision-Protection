// ✅ models/permanent.js
const mongoose = require('mongoose');

const permanentUserSchema = new mongoose.Schema({
  carId: {
    type: String,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  keypass: {
    type: String,
    required: true,
    minlength: 6,
    maxlength: 6,
    match: /^[a-z]{6}$/  // 6 lowercase letters only
  }
});

const PermanentUser = mongoose.model('PermanentUser', permanentUserSchema);
module.exports = PermanentUser;
