const express = require('express');
const router = express.Router();
const CarCompany = require('../models/carcompany'); // ✅ check against company cars

// 🟢 POST /Registration
router.post('/', async (req, res) => {
  const { carId, keypass } = req.body;

  try {
    // 🔍 Check if there's a matching car in the company database
    const match = await CarCompany.findOne({ carId, companyKeypass: keypass });

    if (!match) {
      return res.status(401).json({ message: '❌ carId or keypass is incorrect (not registered in company)' });
    }

    // ✅ Valid car from company database
    res.status(200).json({ message: '✔️ Matched with company car. You can connect vehicle now.' });
  } catch (err) {
    console.error('❌ Error in Registration route:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
