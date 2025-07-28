const express = require('express');
const router = express.Router();
const PermanentUser = require('../models/permanent');
const CarCompany = require('../models/carcompany'); // ✅ استدعاء موديل الشركة

// 🟢 POST /permanent
router.post('/', async (req, res) => {
  const { carId, name, keypass } = req.body;

  try {
    // ✅ التحقق أولًا من أن carId موجود في قاعدة بيانات الشركة
    const companyCar = await CarCompany.findOne({ carId });
    if (!companyCar) {
      return res.status(401).json({ message: '❌ carId not found in company database' });
    }

    // ✅ التحقق من keypass أنه يتكون من 6 حروف small
    const valid = /^[a-z]{6}$/.test(keypass);
    if (!valid) {
      return res.status(400).json({ message: '❌ Invalid keypass. It must be exactly 6 lowercase letters.' });
    }

    // ✅ إنشاء المستخدم الدائم
    const newPermanentUser = new PermanentUser({
      carId,
      name,
      keypass
    });

    await newPermanentUser.save();

    res.status(201).json({
      message: '✔️ Permanent user added successfully',
      carId,
      name,
      keypass
    });
  } catch (err) {
    console.error('❌ Error in permanent route:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
