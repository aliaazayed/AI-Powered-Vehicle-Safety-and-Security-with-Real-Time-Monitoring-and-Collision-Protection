import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2zfroma/constants/app_theme.dart';
import 'package:test2zfroma/models/once_user_local.dart';
import 'package:test2zfroma/models/permanent_user.dart';
import 'package:test2zfroma/provider/auth_provider.dart';
import 'package:test2zfroma/provider/ble_connection_provider.dart';
import 'package:test2zfroma/provider/connect_vehicle_provider.dart';
import 'package:test2zfroma/provider/once_user_provider.dart';
import 'package:test2zfroma/provider/permanent_user_provider.dart';
import 'package:test2zfroma/provider/safety_setting_provider.dart';
import 'package:test2zfroma/provider/user_type_provider.dart';
import 'package:test2zfroma/screens/ble_connection_screen.dart';
import 'package:test2zfroma/screens/connect_vehicle.dart';
import 'package:test2zfroma/screens/home_screen.dart';
import 'package:test2zfroma/screens/login_screen.dart';
import 'package:test2zfroma/screens/manage_users_screen.dart';
import 'package:test2zfroma/screens/safety_setting.dart';
import 'package:test2zfroma/screens/signup_screen.dart';
import 'package:test2zfroma/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final wasLoggedBefore = prefs.getBool('wasLoggedBefore') ?? false;

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Adapter
  Hive.registerAdapter(PermanentUserAdapter());
  Hive.registerAdapter(OnceUserLocalAdapter());
  // Open box for Permanent Users
  await Hive.openBox<PermanentUser>('permanentUsers');
  await Hive.openBox<OnceUserLocal>('onceUsers');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SafetySettingsProvider()),
        ChangeNotifierProvider(create: (_) => PermanentUserProvider()),
        ChangeNotifierProvider(create: (_) => ConnectVehicleProvider()),
        ChangeNotifierProvider(create: (_) => BleConnectionProvider()),
        ChangeNotifierProvider(create: (_) => OnceUserProvider()),
        ChangeNotifierProvider(create: (_) => UserTypeProvider()),
      ],
      child: MyApp(skipAuth: wasLoggedBefore),
    ),
  );
}

// Update MyApp class routes
class MyApp extends StatelessWidget {
  final bool skipAuth;

  const MyApp({super.key, required this.skipAuth});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRIS Car Safety',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      //initialRoute: '/splash',

      home: skipAuth ? const ConnectVehicle() : const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const CarSafetySettingsScreen(),
        '/manage-users': (context) => const ManageUsersScreen(),
        '/safety': (context) => const CarSafetySettingsScreen(),
        '/connect-guest': (context) => const ConnectVehicle(),
        '/ble-connection': (context) => const BleConnectionScreen(),
        '/connect-vehicle': (context) => const ConnectVehicle(),
      },
    );
  }
}
