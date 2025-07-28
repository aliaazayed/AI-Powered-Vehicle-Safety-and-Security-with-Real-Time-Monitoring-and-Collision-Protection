import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // after sign .. save data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', emailController.text.trim());
      await prefs.setString('password', passwordController.text);
      print("${prefs.getString('email')}");
      // go to next page
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/connect-vehicle', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
