const express = require('express');
const router = express.Router();
const PermanentUser = require('../models/permanent');

// 🟢 POST /invitation
router.post('/', async (req, res) => {
  const { carId, keypass } = req.body;

  try {
    // التحقق من وجود مستخدم دائم مطابق
    const match = await PermanentUser.findOne({ carId, keypass });

    if (!match) {
      return res.status(401).json({ message: '❌ Invalid carId or keypass' });
    }

    res.status(200).json({
      message: '✔️ Invitation verified successfully',
      user: {
        carId: match.carId,
        name: match.name
      }
    });
  } catch (err) {
    console.error('❌ Error verifying invitation:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
