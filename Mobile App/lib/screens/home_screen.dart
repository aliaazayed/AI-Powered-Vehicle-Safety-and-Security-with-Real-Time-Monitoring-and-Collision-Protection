import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/auth_provider.dart';
import 'package:test2zfroma/provider/connect_vehicle_provider.dart';
import 'package:test2zfroma/provider/user_type_provider.dart';
import 'package:test2zfroma/screens/ble_connection_screen.dart';
import 'package:test2zfroma/screens/gps_screen.dart';
import 'package:test2zfroma/screens/history_screen.dart';
import 'package:test2zfroma/screens/not_screen.dart';
import 'package:test2zfroma/screens/settings_screen.dart';
import 'package:test2zfroma/widgets//ellipse_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double ellipseHeight = screenHeight * 0.06;
    double ellipseWidth = screenWidth * 0.60;
    double ellipseFont = screenHeight * 0.023;

    // IMPORTANT

    final provider =
        Provider.of<ConnectVehicleProvider>(context, listen: false);
    final carId = provider.savedCarId;
    final keypass = provider.savedKeypass;
    final name = provider.savedUserName;
    final userType = Provider.of<UserTypeProvider>(context).userType;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: screenWidth * 0.021),
            Icon(Icons.directions_car, color: AppColors.primary),
            SizedBox(width: screenWidth * 0.021),
            Text('Home', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.052),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: AppColors.textPrimary, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome to IRIS',
                      style: TextStyle(
                        fontSize: screenHeight * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        final user = authProvider.user;

                        if (user != null && user['profileImage'] != null) {
                          return CircleAvatar(
                            radius: 18,
                            backgroundImage: FileImage(user['profileImage']!),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.inputBackground,
                            child: Icon(Icons.person, color: AppColors.primary),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.001),
                Text(
                  'Connecting you with your car : $carId',
                  style: TextStyle(
                    fontSize: screenHeight * 0.019,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live GPS location',
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GpsPage(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              'assets/images/map.jpg',
                              height: screenHeight * 0.25,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Center(
                  child: EllipseButton(
                    text: 'Connect & Control',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BleConnectionScreen()),
                      );
                    },
                    height: ellipseHeight,
                    width: ellipseWidth,
                    fontSize: ellipseFont,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildInfoCard(
                  screenWidth,
                  screenHeight,
                  title: 'Settings',
                  subtitle: 'Manage your preferences',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                _buildInfoCard(
                  screenWidth,
                  screenHeight,
                  title: 'Notifications',
                  subtitle: 'Stay updated with alerts',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage()),
                    );
                  },
                ),
                if (userType != 'once')
                  _buildInfoCard(
                    screenWidth,
                    screenHeight,
                    title: 'History',
                    subtitle: 'View recent activities and connections',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserHistoryScreen()),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    double screenWidth,
    double screenHeight, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: screenHeight * 0.012),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.018,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenHeight * 0.025,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: screenHeight * 0.017,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
