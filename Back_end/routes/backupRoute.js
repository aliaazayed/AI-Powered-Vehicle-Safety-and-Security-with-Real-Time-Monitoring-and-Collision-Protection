const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();

router.get('/backup/:collection', (req, res) => {
  const collection = req.params.collection;
  const backupPath = path.join(__dirname, `../backup/${collection}.json`);

  if (!fs.existsSync(backupPath)) {
    return res.status(404).json({ message: 'Backup file not found' });
  }

  try {
    const data = fs.readFileSync(backupPath, 'utf-8');
    res.json(JSON.parse(data));
  } catch (err) {
    res.status(500).json({ message: 'Error reading backup file', error: err.message });
  }
});

module.exports = router;
