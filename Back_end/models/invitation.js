// ✅ models/invitation.js
const mongoose = require('mongoose');

const invitationSchema = new mongoose.Schema({
  carId: {
    type: String,
    required: true
  },
  keypass: {
    type: String,
    required: true,
    minlength: 6,
    maxlength: 6,
    match: /^[a-z]{6}$/ // 6 lowercase letters only
  }
});

const Invitation = mongoose.model('Invitation', invitationSchema);
module.exports = Invitation;
