import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/signup_provider.dart';
import 'package:test2zfroma/widgets/custom_textformfield.dart';
import 'package:test2zfroma/widgets/primary_button.dart';
import 'package:test2zfroma/widgets/profile_avatar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: const _SignupScreenContent(),
    );
  }
}

class _SignupScreenContent extends StatelessWidget {
  const _SignupScreenContent();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.person_add_alt_1_outlined,
                color: AppColors.primary, size: media.width * 0.06),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: media.width * 0.048,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(media.width * 0.05),
          child: Form(
            key: provider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                    color: AppColors.textPrimary, height: 1, thickness: 1),
                SizedBox(height: media.height * 0.02),
                Text(
                  'Welcome To IRIS',
                  style: TextStyle(
                    fontSize: media.width * 0.065,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: media.height * 0.01),
                Text(
                  'Join IRIS and keep your car safe',
                  style: TextStyle(
                    fontSize: media.width * 0.04,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: media.height * 0.03),

                // Avatar
                Center(
                  child: ProfileAvatar(
                    profileImage: provider.profileImage,
                    onTap: () => provider.showImageSourceDialog(context),
                  ),
                ),
                SizedBox(height: media.height * 0.03),

                // Full Name
                CustomTextField(
                  controller: provider.nameController,
                  label: 'Full Name',
                  hintText: 'Your name',
                  prefixIcon: Icons.person_outline,
                  validator: provider.validateName,
                ),
                SizedBox(height: media.height * 0.025),

                // Phone
                CustomTextField(
                  controller: provider.phoneController,
                  label: 'Phone Number',
                  hintText: '+20 (010) 000-0000',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: provider.validatePhone,
                ),
                SizedBox(height: media.height * 0.025),

                // Email
                CustomTextField(
                  controller: provider.emailController,
                  label: 'Email',
                  hintText: 'you@gmail.com',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: provider.validateEmail,
                ),
                SizedBox(height: media.height * 0.025),

                // Password
                CustomTextField(
                  controller: provider.passwordController,
                  label: 'Password',
                  hintText: '*******',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: provider.togglePasswordVisibility,
                  ),
                  obscureText: !provider.passwordVisible,
                  validator: provider.validatePassword,
                ),
                SizedBox(height: media.height * 0.025),

                // Confirm Password
                CustomTextField(
                  controller: provider.confirmPasswordController,
                  label: 'Confirm Password',
                  hintText: '*******',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.confirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: provider.toggleConfirmPasswordVisibility,
                  ),
                  obscureText: !provider.confirmPasswordVisible,
                  validator: provider.validateConfirmPassword,
                ),
                SizedBox(height: media.height * 0.035),

                // Continue Button
                PrimaryButton(
                  text: 'Continue',
                  trailingIcon: Icons.arrow_forward,
                  isLoading: provider.isLoading,
                  onPressed: () {
                    if (!provider.isLoading) {
// Remove the duplicate navigation - let the provider handle it
                      provider.signup(context);
                    }
                  },
                ),

                SizedBox(height: media.height * 0.03),

                // API Connection Status (for debugging - remove in production)
                if (provider.isLoading)
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          'Connecting to IRIS Cloud...',
                          style: TextStyle(
                            fontSize: media.width * 0.035,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: media.height * 0.02),

                // Navigate to Login
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: media.width * 0.038,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: media.width * 0.038,
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
