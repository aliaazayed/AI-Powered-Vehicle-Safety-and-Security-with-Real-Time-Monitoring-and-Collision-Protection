import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/auth_provider.dart';
import 'package:test2zfroma/provider/connect_vehicle_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to IRIS',
      'subtitle': 'One App, Every Access',
      'image': 'assets/images/logo_s.jpg',
    },
    {
      'title': 'Secure & Smart',
      'subtitle': 'Share the Journey, Not the Keys',
      'image': 'assets/images/car4.jpg',
    },
    {
      'title': "Let's Get Started!",
      'subtitle': 'Connected. Controlled. Secured.',
      'image': 'assets/images/car3.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initializeAuth(); // مهم جدًا

    if (!isFirstTime && authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(
          context, '/connect-vehicle'); // أو /home لو تفضلين
    }
    // else → يبقى على SplashScreen ويكمل onboarding
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _finishSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final wasLoggedBefore = prefs.getBool('wasLoggedBefore') ?? false;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initializeAuth();
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/connect-vehicle');
    } else {
      Navigator.pushReplacementNamed(context, '/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return Padding(
                    padding: EdgeInsets.all(media.width * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(page['image']!, height: media.height * 0.5),
                        SizedBox(height: media.height * 0.0),
                        Text(
                          page['title']!,
                          style: TextStyle(
                            fontSize: media.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: media.height * 0.02),
                        Text(
                          page['subtitle']!,
                          style: TextStyle(
                            fontSize: media.width * 0.045,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Next / Start button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _currentIndex == _pages.length - 1
                          ? _finishSplash
                          : () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _pages.length - 1 ? 'Start' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Continue as Guest button
                  if (_currentIndex == _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        final connectProvider =
                            Provider.of<ConnectVehicleProvider>(context,
                                listen: false);
                        connectProvider.setGuest(true);
                        Navigator.pushReplacementNamed(
                            context, '/connect-vehicle');
                      },
                      child: const Text(
                        'Continue as a Guest',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
