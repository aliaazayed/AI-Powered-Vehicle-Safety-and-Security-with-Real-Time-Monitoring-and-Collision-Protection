import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test2zfroma/constants/app_color.dart';

class ProfileAvatar extends StatelessWidget {
  final File? profileImage;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    this.profileImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F9),
            shape: BoxShape.circle,
            image: profileImage != null
                ? DecorationImage(
                    image: FileImage(profileImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: profileImage == null
              ? const Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: 60,
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
