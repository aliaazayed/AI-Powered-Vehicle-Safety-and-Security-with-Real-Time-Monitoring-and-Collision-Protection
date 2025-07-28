import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/safety_setting_provider.dart';
import 'package:test2zfroma/widgets/setting_tile.dart';

class CarSafetySettingsScreen extends StatefulWidget {
  const CarSafetySettingsScreen({super.key});

  @override
  State<CarSafetySettingsScreen> createState() =>
      _CarSafetySettingsScreenState();
}

class _CarSafetySettingsScreenState extends State<CarSafetySettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh settings when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SafetySettingsProvider>().refreshSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: media.width * 0.07,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Manage Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: media.width * 0.048,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Refresh button
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.primary),
              onPressed: () {
                context.read<SafetySettingsProvider>().refreshSettings();
              },
            ),
          ],
        ),
        body: Consumer<SafetySettingsProvider>(builder: (context, provider, _) {
          // Show loading state
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your settings...'),
                ],
              ),
            );
          }

          // Show error state
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearError();
                        provider.refreshSettings();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show settings if available
          if (provider.settings == null) {
            return const Center(
              child: Text('No settings available'),
            );
          }

          final settings = provider.settings!;

          return Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(
                  color: AppColors.textPrimary,
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 16),

                // Show first time user message
                if (provider.isFirstTime) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Welcome to Notification Settings!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All notifications are disabled by default. Enable the ones you want to receive.',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Settings tiles
                EnhancedSettingTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Authorized Access',
                  description: 'Control who can access your car.',
                  value: settings.authorizedAccess,
                  onChanged: provider.isSaving
                      ? null
                      : (value) {
                          provider.updateAuthorizedAccess(value);
                        },
                ),
                const SizedBox(height: 16),
                EnhancedSettingTile(
                  icon: Icons.child_care_outlined,
                  title: 'Child Detection',
                  description: 'Detects if a child is left inside the vehicle.',
                  value: settings.childDetection,
                  onChanged: provider.isSaving
                      ? null
                      : (value) {
                          provider.updateChildDetection(value);
                        },
                ),
                const SizedBox(height: 16),
                EnhancedSettingTile(
                  icon: Icons.pets_outlined,
                  title: 'Pet Detection',
                  description: 'Alerts if a pet is left inside.',
                  value: settings.authorizedAccess,
                  onChanged: provider.isSaving
                      ? null
                      : (value) {
                          provider.updatePetDetection(value);
                        },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }));
  }
}


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/safety_setting_provider.dart';
import 'package:test2zfroma/widgets/setting_tile.dart';

class CarSafetySettingsScreen extends StatelessWidget {
  const CarSafetySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.notifications_outlined,
                color: AppColors.primary, size: media.width * 0.07),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Manage Notifications',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: media.width * 0.048,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 16),
        child: Consumer<SafetySettingsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = provider.settings!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(
                  color: AppColors.textPrimary,
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                SettingTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Authorized Access',
                  description: 'Control who can access your car.',
                  value: settings.authorizedAccess,
                  onChanged: (value) => provider.updateAuthorizedAccess(value),
                ),
                const SizedBox(height: 16),
                SettingTile(
                  icon: Icons.child_care_outlined,
                  title: 'Child Detection',
                  description: 'Detects if a child is left inside the vehicle.',
                  value: settings.childDetection,
                  onChanged: (value) => provider.updateChildDetection(value),
                ),
                const SizedBox(height: 16),
                SettingTile(
                  icon: Icons.pets_outlined,
                  title: 'Pet Detection',
                  description: 'Alerts if a pet is left inside.',
                  value: settings.petDetection,
                  onChanged: (value) => provider.updatePetDetection(value),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
*/