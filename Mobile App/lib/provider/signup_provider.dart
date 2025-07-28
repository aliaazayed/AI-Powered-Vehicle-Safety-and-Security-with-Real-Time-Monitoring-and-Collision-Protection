import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test2zfroma/screens/connect_vehicle.dart';
import 'package:test2zfroma/services/azure_api_services.dart';

import '../constants/app_color.dart';

class SignupProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  bool _disposed = false; // Add disposal tracking
  File? profileImage;
  final ImagePicker imagePicker = ImagePicker();

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        notifyListeners();

        // Show success feedback
        print('Image selected: ${pickedFile.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
      // Handle image picking errors gracefully
    }
  }

  Future<void> signup(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    // Validate password confirmation
    if (passwordController.text != confirmPasswordController.text) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      // Show different loading messages
      if (profileImage != null) {
        _showLoadingMessage(context, 'Creating account with profile image...');
      } else {
        _showLoadingMessage(context, 'Creating your account...');
      }

      // Call the Azure API with form-data approach
      Map<String, dynamic> result;

      try {
        // Try with profile image first (or without if no image selected)
        result = await AzureApiService.registerUser(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          password: passwordController.text,
          profileImage: profileImage,
        );
      } catch (e) {
        // If registration fails and we had an image, try without image as fallback
        if (profileImage != null && e.toString().contains('ProfileImage')) {
          print('Registration with image failed, trying without image...');
          _showLoadingMessage(context, 'Retrying without profile image...');

          result = await AzureApiService.registerUserWithoutImage(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            password: passwordController.text,
          );
        } else {
          rethrow;
        }
      }

      if (context.mounted) {
        // Hide loading message
        ScaffoldMessenger.of(context).clearSnackBars();

        if (result['success'] == true) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileImage != null
                  ? 'Account created successfully with profile image! Welcome to IRIS.'
                  : 'Account created successfully! Welcome to IRIS.'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate to ConnectVehicle after successful signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ConnectVehicle()),
          );
        } else {
          throw Exception(result['message'] ?? 'Registration failed');
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Hide loading message
        ScaffoldMessenger.of(context).clearSnackBars();

        String errorMessage = _getErrorMessage(e.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => signup(context),
            ),
          ),
        );
      }
      print('Signup error: $e');
    } finally {
      // Remove the mounted check - just update the loading state
      if (!_disposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void _showLoadingMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: const Duration(minutes: 5), // Long duration
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('already exists')) {
      return 'An account with this email already exists.';
    } else if (error.contains('internet connection') ||
        error.contains('network')) {
      return 'No internet connection. Please check your network.';
    } else if (error.contains('ProfileImage') && error.contains('required')) {
      return 'Profile image is required. Please select an image and try again.';
    } else if (error.contains('Invalid response format')) {
      return 'Server communication error. Please try again.';
    } else if (error.contains('Image upload failed')) {
      return 'Failed to upload profile image. Please try a different image.';
    } else if (error.contains('timeout')) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (error.contains('Server error')) {
      return 'Server is experiencing issues. Please try again later.';
    } else if (error.contains('Invalid input')) {
      return 'Please check your input and try again.';
    } else {
      return 'Registration failed. Please try again.';
    }
  }

  void showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Gallery'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                ),
                GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                ),
                // Add option to skip image
                GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Skip for now'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    profileImage = null;
                    notifyListeners();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Validation methods remain the same...
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    String cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    profileImage = null;
    passwordVisible = false;
    confirmPasswordVisible = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true; // Mark as disposed
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
