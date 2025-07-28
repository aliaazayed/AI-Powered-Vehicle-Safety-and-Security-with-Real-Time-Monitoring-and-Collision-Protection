
const express = require('express');
const router = express.Router();
const Device = require('../models/device');

router.post('/', async (req, res) => {
  const { raspberryModel, espType } = req.body;

  if (!raspberryModel || !espType) {
    return res.status(400).json({ message: 'Missing fields' });
  }

  const newDevice = await Device.create({ raspberryModel, espType });
  res.status(201).json({ message: 'Device registered', device: newDevice });
});

module.exports = router;
