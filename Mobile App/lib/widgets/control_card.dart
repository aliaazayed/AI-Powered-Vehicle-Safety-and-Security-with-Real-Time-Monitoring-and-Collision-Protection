import 'package:flutter/material.dart';
import 'package:test2zfroma/constants/app_color.dart';

class ControlCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final String? time;
  final VoidCallback onTap;

  const ControlCard({
    super.key,
    this.icon,
    this.time,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null)
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary),
                    SizedBox(width: screenWidth * 0.009),
                    Text(title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: screenHeight * 0.019,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )
              else
                Text(title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: screenHeight * 0.019,
                      fontWeight: FontWeight.bold,
                    )),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: screenHeight * 0.015)),
              const SizedBox(height: 4),
              if (time != null)
                Text(time!,
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: screenHeight * 0.015))
            ],
          ),
        ),
      ),
    );
  }
}

class ControlCardWithDelete extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final String? time;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ControlCardWithDelete({
    super.key,
    this.icon,
    this.time,
    required this.title,
    required this.subtitle,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // المحتوى الأساسي
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null)
                      Row(
                        children: [
                          Icon(icon, color: AppColors.primary),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: screenHeight * 0.019,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: screenHeight * 0.019,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: screenHeight * 0.015,
                      ),
                    ),
                    if (time != null)
                      Text(
                        time!,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: screenHeight * 0.015,
                        ),
                      ),
                  ],
                ),
              ),
              // زر الحذف
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
