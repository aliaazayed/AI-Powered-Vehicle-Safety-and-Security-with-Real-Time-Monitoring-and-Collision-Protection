import 'package:flutter/material.dart';
import 'package:test2zfroma/constants/app_color.dart';

class EnhancedSettingTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isLoading;
  final Color? iconColor;
  final Color? backgroundColor;

  const EnhancedSettingTile({
    super.key,
    this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final isDisabled = onChanged == null || isLoading;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isDisabled ? null : () => onChanged?.call(!value),
          child: Padding(
            padding: EdgeInsets.all(media.width * 0.04),
            child: Row(
              children: [
                // Icon section
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primary,
                      size: media.width * 0.06,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],

                // Content section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: media.width * 0.044,
                          fontWeight: FontWeight.w600,
                          color: isDisabled ? Colors.grey[600] : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: media.width * 0.036,
                          color: isDisabled
                              ? Colors.grey[500]
                              : AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch section
                if (isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ] else ...[
                  Switch.adaptive(
                    activeColor: AppColors.primary,
                    value: value,
                    onChanged: onChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Legacy SettingTile for backward compatibility
class SettingTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingTile({
    super.key,
    this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedSettingTile(
      icon: icon,
      title: title,
      description: description,
      value: value,
      onChanged: onChanged,
    );
  }
}
