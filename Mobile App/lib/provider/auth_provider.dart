import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2zfroma/services/azure_api_services.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
  String? _token;
  bool _isLoading = false;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoggedIn => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  Future<void> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');

      if (_token != null && userJson != null) {
        _user = jsonDecode(userJson);
        _isAuthenticated = true;

        final isValid = await validateSession();
        if (!isValid) {
          await signout();
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error initializing auth: $e');
      await signout();
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    File? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AzureApiService.registerUser(
        name: name,
        email: email,
        phoneNumber: phone,
        password: password,
        profileImage: profileImage,
      );

      _user = result['user'];
      _token = result['token'];
      _isAuthenticated = true;

      await _saveAuthData();
      notifyListeners();
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AzureApiService.loginUser(
        email: email,
        password: password,
      );

      _user = result['user'];
      _token = result['token'];
      _isAuthenticated = true;

      await _saveAuthData();
      notifyListeners();
    } catch (e) {
      print('Signin error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signout() async {
    try {
      _isAuthenticated = false;
      _user = null;
      _token = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.setBool('isFirstTime', true);

      notifyListeners();
    } catch (e) {
      print('Signout error: $e');
    }
  }
  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
    }
    if (_user != null) {
      await prefs.setString('user_data', jsonEncode(_user));
    }

    await prefs.setBool('wasLoggedBefore', true);
  }

  Future<bool> validateSession() async {
    if (_token == null) return false;
    try {
      final result = await AzureApiService.validateToken(_token!);
      return result['success'] == true;
    } catch (e) {
      print('Session validation error: $e');
      return false;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    File? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AzureApiService.updateUserProfile(
        token: _token!,
        name: name,
        phoneNumber: phone,
        profileImage: profileImage,
      );

      _user = result['user'];
      await _saveAuthData();
      notifyListeners();
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Display helpers

  String get userName => _user?['Name'] ?? _user?['name'] ?? 'User';
  String get userEmail => _user?['Email'] ?? _user?['email'] ?? '';
  String get userPhone => _user?['phoneNumber'] ?? _user?['phone'] ?? '';
  String? get userProfileImage => _user?['ProfileImage'] ?? _user?['profileImage'];
  bool get isProfileImageUrl => userProfileImage != null && userProfileImage!.startsWith('http');
  File? get userProfileImageFile {
    final path = userProfileImage;
    if (path != null && !path.startsWith('http')) {
      final file = File(path);
      return file.existsSync() ? file : null;
    }
    return null;
  }
}
