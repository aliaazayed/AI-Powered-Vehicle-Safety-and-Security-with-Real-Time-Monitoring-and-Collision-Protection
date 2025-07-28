const mongoose = require('mongoose');

const carCompanySchema = new mongoose.Schema({
  carId: {
    type: String,
    required: true,
    unique: true
  },
  companyKeypass: {
    type: String,
    required: true,
    match: /^[a-z]{6}$/ // exactly 6 lowercase letters
  }
});

module.exports = mongoose.model('CarCompany', carCompanySchema);
