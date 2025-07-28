// ✅ models/notification.js
const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId, // مهم جدًا يكون ObjectId
    ref: 'User', // الربط بالموديل الأساسي
    required: true
  },
  childDetectionAlert: {
    type: String,
    enum: ['yes', 'no'],
    default: 'no'
  },
  petDetectionAlert: {
    type: String,
    enum: ['yes', 'no'],
    default: 'no'
  },
  unauthorizedAccess: {
    type: String,
    enum: ['yes', 'no'],
    default: 'no'
  }
});

module.exports = mongoose.model('Notification', notificationSchema);
