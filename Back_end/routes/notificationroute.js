const express = require('express');
const router = express.Router();
const Notification = require('../models/notification');

// 🟢 POST /notifications/:userId → Update or Create notification
router.post('/:userId', async (req, res) => {
  const { userId } = req.params;
  const { childDetectionAlert, petDetectionAlert, unauthorizedAccess } = req.body;

  try {
    let notification = await Notification.findOne({ userId });

    if (notification) {
      // ✅ Update existing notification
      notification.childDetectionAlert = childDetectionAlert;
      notification.petDetectionAlert = petDetectionAlert;
      notification.unauthorizedAccess = unauthorizedAccess;
      await notification.save();
    } else {
      // ✅ Create new notification
      notification = new Notification({
        userId,
        childDetectionAlert,
        petDetectionAlert,
        unauthorizedAccess
      });
      await notification.save();
    }

    res.status(200).json({
      message: 'Notification updated successfully',
      notification
    });
  } catch (err) {
    console.error('❌ Error:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// 🟢 GET /notifications/:userId → Get notification for specific user
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const notification = await Notification.findOne({ userId });

    if (!notification) {
      return res.status(404).json({ message: '❌ No notification found for this user' });
    }

    res.status(200).json(notification);
  } catch (err) {
    console.error('❌ Error fetching notification:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
