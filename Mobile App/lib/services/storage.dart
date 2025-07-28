import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _settingsKey = 'safety_settings';
  static const String _userIdKey = 'user_id';
  static const String _isFirstTimeKey = 'is_first_time';

  // Save user ID
  static Future<void> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userId);
    } catch (e) {
      debugPrint('Error saving user ID: $e');
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      debugPrint('Error getting user ID: $e');
      return null;
    }
  }

  // Check if this is the first time user is accessing settings
  static Future<bool> isFirstTime(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('${_isFirstTimeKey}_$userId') ?? true;
    } catch (e) {
      debugPrint('Error checking first time: $e');
      return true;
    }
  }

  // Mark that user has accessed settings
  static Future<void> markFirstTimeComplete(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${_isFirstTimeKey}_$userId', false);
    } catch (e) {
      debugPrint('Error marking first time complete: $e');
    }
  }

  // Save safety settings locally (backup)
  static Future<void> saveSafetySettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings);
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Error saving safety settings: $e');
    }
  }

  // Get safety settings from local storage
  static Future<Map<String, dynamic>?> getSafetySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        return json.decode(settingsJson);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting safety settings: $e');
      return null;
    }
  }

  // Clear all stored data (for logout)
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }

  // Clear specific user data
  static Future<void> clearUserData(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_isFirstTimeKey}_$userId');
      await prefs.remove(_settingsKey);
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }
}
