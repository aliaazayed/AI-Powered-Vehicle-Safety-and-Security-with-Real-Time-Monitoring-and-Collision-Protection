const express = require('express');
const CarCompany = require('../models/carcompany');

const router = express.Router();

// GET all car entries (only carId and companyKeypass)
router.get('/all', async (req, res) => {
  try {
    const cars = await CarCompany.find({})
      .select('carId companyKeypass -_id');
    res.status(200).json(cars);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving company car data', error: error.message });
  }
});

// Seed initial test data
router.get('/seed', async (req, res) => {
  try {
    const existingCount = await CarCompany.countDocuments();
    if (existingCount > 0) {
      return res.status(200).json({ message: 'Company car data already initialized' });
    }

    const testCars = [
      { carId: 'CAR001', companyKeypass: 'abcxyz' },
      { carId: 'CAR002', companyKeypass: 'defghi' },
      { carId: 'CAR003', companyKeypass: 'jklmno' },
      { carId: 'CAR004', companyKeypass: 'pqrstu' },
      { carId: 'CAR005', companyKeypass: 'vwxyza' },
      { carId: 'BMW001', companyKeypass: 'ghijkl' },
      { carId: 'AUDI02', companyKeypass: 'mnopqr' },
      { carId: 'TESLA3', companyKeypass: 'stuvwx' },
      { carId: 'FORD55', companyKeypass: 'yzabcd' },
      { carId: 'TOY999', companyKeypass: 'efghij' }
    ];

    await CarCompany.insertMany(testCars);
    res.status(201).json({ message: 'Company car data seeded successfully' });

  } catch (error) {
    console.error('Error seeding data:', error);
    res.status(500).json({ message: 'Failed to seed data', error: error.message });
  }
});

module.exports = router;
