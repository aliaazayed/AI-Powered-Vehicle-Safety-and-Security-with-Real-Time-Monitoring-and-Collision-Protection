const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const OnceUser = require('../models/once');
const CarCompany = require('../models/carcompany');

// ✅ إعداد multer لرفع الصور
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + '-' + file.originalname;
    cb(null, uniqueName);
  }
});
const upload = multer({ storage: storage });

// 🟢 POST /once (BLE or Face)
router.post('/', upload.single('FaceImage'), async (req, res) => {
  const { carId, name, keypass } = req.body;

  try {
    // ✅ التحقق من الحقول الأساسية
    if (!carId || !name) {
      return res.status(400).json({ message: 'carId and name are required' });
    }

    // ✅ التحقق من carId في الشركة
    const carExists = await CarCompany.findOne({ carId });
    if (!carExists) {
      return res.status(404).json({ message: '❌ carId not found in company database' });
    }

    // ✅ الحالة 1: BLE mode (لا صورة، keypass مطلوب من الفرونت)
    if (!req.file && keypass) {
      // ✅ تحقق من صلاحية keypass
      const valid = /^[a-z]{5}$/.test(keypass);
      if (!valid) {
        return res.status(400).json({ message: '❌ keypass must be exactly 5 lowercase letters' });
      }

      const user = new OnceUser({
        carId,
        name,
        keypass
      });

      await user.save();

      return res.status(201).json({
        message: '✔️ BLE once user saved',
        user: {
          carId: user.carId,
          name: user.name,
          keypass: user.keypass
        }
      });
    }

    // ✅ الحالة 2: Face mode (صورة فقط، بدون keypass)
    if (req.file && !keypass) {
      const imagePath = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;

      const user = new OnceUser({
        carId,
        name,
        FaceImage: imagePath
      });

      await user.save();

      return res.status(201).json({
        message: '✔️ Face once user saved',
        user: {
          carId: user.carId,
          name: user.name,
          FaceImage: user.FaceImage
        }
      });
    }

    // ❌ لو بعثت الاثنين أو ولا واحد فيهم
    return res.status(400).json({
      message: 'Send either keypass (BLE) or FaceImage (Face), not both or none.'
    });

  } catch (err) {
    console.error('❌ Error in once route:', err.message);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
