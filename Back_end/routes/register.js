const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const multer = require('multer');
const path = require('path');
const User = require('../models/User');

// إعداد التخزين
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // مكان حفظ الصور
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + '-' + file.originalname;
    cb(null, uniqueName);
  }
});

// الفلتر (اختياري) – نحدد أنواع الملفات المسموحة
const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/png'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Only jpeg and png are allowed'), false);
  }
};

// إعداد `multer`
const upload = multer({ storage: storage, fileFilter: fileFilter });

// 🟢 POST /register (مع صورة)
router.post('/', upload.single('ProfileImage'), async (req, res) => {
  const { Name, Email, Password, phoneNumber } = req.body;

  try {
    const existingUser = await User.findOne({ Email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(Password, 10);

    const profileImagePath = req.file
      ? `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`
      : null;

    const newUser = new User({
      Name,
      Email,
      Password: hashedPassword,
      phoneNumber,
      ProfileImage: profileImagePath,
    });

    await newUser.save();

    console.log('✅ User registered:', {
      Name: newUser.Name,
      Email: newUser.Email,
      ProfileImage: newUser.ProfileImage,
    });

    res.status(201).json({
      message: 'User registered successfully',
      user: {
        Name: newUser.Name,
        Email: newUser.Email,
        phoneNumber: newUser.phoneNumber,
        ProfileImage: newUser.ProfileImage,
      },
    });
  } catch (err) {
    console.error('❌ Error registering user:', err.message);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
