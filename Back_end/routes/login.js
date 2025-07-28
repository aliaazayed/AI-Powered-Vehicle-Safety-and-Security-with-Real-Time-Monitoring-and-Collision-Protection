const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const User = require('../models/User');

// POST /login
router.post('/', async (req, res) => {
  const { Email, Password } = req.body;

  try {
    // Check if user with given email exists
    const user = await User.findOne({ Email });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Compare the provided password with the hashed password
    const isMatch = await bcrypt.compare(Password, user.Password);

    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid password' });
    }

    // If everything is OK
    res.status(200).json({
      message: 'Login successful',
      user: {
        id: user._id,
        Name: user.Name,
        Email: user.Email,
        phoneNumber: user.phoneNumber,
        ProfileImage: user.ProfileImage
        // ⚠️ Do NOT return the password
      }
    });

  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
