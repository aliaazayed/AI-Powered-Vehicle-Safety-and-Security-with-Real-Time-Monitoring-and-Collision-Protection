import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/auth_provider.dart';
import 'package:test2zfroma/provider/user_type_provider.dart';
import 'package:test2zfroma/screens/manage_users_screen.dart';
import 'package:test2zfroma/screens/safety_setting.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<UserTypeProvider>(context).userType;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.settings, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(
                        color: AppColors.textPrimary,
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),

                      // Cards
                      _buildManageNotificationsCard(),
                      const SizedBox(height: 16),
                      if (userType == 'owner') ...[
                        _buildManageUsersCard(),
                        const SizedBox(height: 16),
                      ],

                      const Spacer(),

                      // Sign Out
                      _buildSignOutCard(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildManageNotificationsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarSafetySettingsScreen(),
            ),
          );

          // Handle tap
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.notifications_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Manage Notifications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Configure your notification preferences',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageUsersCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageUsersScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.people_outline_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Manage Users',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'View and remove Current users',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSignOutCard(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: InkWell(
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Confirm Sign Out',
                  style: TextStyle(color: AppColors.primary)),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Sign Out',
                      style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );

          if (confirm == true && context.mounted) {
            final prefs = await SharedPreferences.getInstance();

            // حذف بيانات الدخول

            await prefs.setBool('wasLoggedBefore', false); // نعيده كأنه أول مرة
            await context.read<AuthProvider>().signout();

            // تسجيل الخروج من مزود الحالة
            await context.read<AuthProvider>().signout();

            // الرجوع إلى SplashScreen وحذف كل الشاشات السابقة
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Sign Out',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
