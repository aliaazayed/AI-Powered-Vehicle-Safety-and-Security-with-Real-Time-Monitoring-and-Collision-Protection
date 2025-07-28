const mongoose = require('mongoose');

const connectVehicleSchema = new mongoose.Schema({
  carId: {
    type: String,
    required: true
  },
  keypass: {
    type: String,
    required: true,
    minlength: 6,
    maxlength: 6,
    match: /^[a-z]{6}$/  // 6 حروف صغيرة فقط
  }
});

const ConnectVehicle = mongoose.model('ConnectVehicle', connectVehicleSchema);

module.exports = ConnectVehicle;
