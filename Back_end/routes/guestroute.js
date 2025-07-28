const express = require('express');
const router = express.Router();
const OnceUser = require('../models/once'); // ✅ هنا بنستخدم نفس موديل once

// 🟢 POST /guest
router.post('/', async (req, res) => {
  const { carId, keypass } = req.body;

  try {
    // ✅ تأكد إن carId و keypass موجودين في جدول once
    const user = await OnceUser.findOne({ carId, keypass });

    if (!user) {
      return res.status(401).json({ message: '❌ Invalid guest credentials' });
    }

    res.status(200).json({
      message: '✔️ Guest verified successfully',
      guest: {
        carId: user.carId,
        name: user.name
      }
    });
  } catch (err) {
    console.error('❌ Error in guest route:', err.message);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
