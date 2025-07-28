const mongoose = require('mongoose');

const onceUserSchema = new mongoose.Schema({
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
  minlength: 5,
  maxlength: 5,
  match: /^[a-z]{5}$/,
  required: false
},
FaceImage: {
  type: String,
  required: false
}

  
});

const OnceUser = mongoose.model('OnceUser', onceUserSchema);
module.exports = OnceUser;
