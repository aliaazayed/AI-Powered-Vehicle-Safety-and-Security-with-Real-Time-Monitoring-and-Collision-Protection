import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/widgets/custom_textformfield.dart';
import 'package:test2zfroma/widgets/primary_button.dart';

import '../provider/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(media.width * 0.06),
          child: Form(
            key: provider.formKey, // Add form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: media.width * 0.075,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: media.height * 0.01),
                Text(
                  'Sign in to your IRIS account',
                  style: TextStyle(
                    fontSize: media.width * 0.04,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: media.height * 0.04),

                // Email Field
                CustomTextField(
                  controller: provider.emailController,
                  label: 'Email',
                  hintText: 'you@gmail.com',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Please enter your email';
                    }
                    final regex = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                    if (!regex.hasMatch(trimmed)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: media.height * 0.025),

                // Password Field
                CustomTextField(
                  controller: provider.passwordController,
                  label: 'Password',
                  hintText: '********',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !provider.passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: provider.togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                SizedBox(height: media.height * 0.015),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Password reset functionality coming soon')),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: media.height * 0.04),

                // Login Button
                PrimaryButton(
                  text: 'Sign In',
                  isLoading: provider.isLoading,
                  onPressed: () => provider.login(context),
                ),
                SizedBox(height: media.height * 0.03),

                // Navigate to Sign Up
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: media.width * 0.04,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
