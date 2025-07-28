import 'package:flutter/material.dart';
import 'package:test2zfroma/models/safety_setting.dart';
import 'package:test2zfroma/services/api_services.dart';
import 'package:test2zfroma/services/storage.dart';

class SafetySettingsProvider extends ChangeNotifier {
  SafetySettings? _settings;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  String? _userId;
  bool _isFirstTime = true;

  // Getters
  SafetySettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool get isFirstTime => _isFirstTime;

  SafetySettingsProvider() {
    _initializeSettings();
  }

  // Initialize settings when provider is created
  Future<void> _initializeSettings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get user ID from storage
      _userId = await StorageService.getUserId();

      if (_userId == null) {
        throw Exception('User not logged in');
      }

      // Check if this is first time
      _isFirstTime = await StorageService.isFirstTime(_userId!);

      await _loadSettings();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error initializing settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load settings from database
  Future<void> _loadSettings() async {
    try {
      if (_userId == null) return;

      // Try to get settings from API
      final response = await ApiService.getUserNotificationSettings(_userId!);

      if (response['success'] == true) {
        _settings = SafetySettings.fromJson(response['data']);

        // Save to local storage as backup
        await StorageService.saveSafetySettings(_settings!.toMap());

        // Mark first time as complete if settings exist
        if (!_isFirstTime) {
          await StorageService.markFirstTimeComplete(_userId!);
        }
      } else {
        // If API fails, try to load from local storage
        final localSettings = await StorageService.getSafetySettings();
        if (localSettings != null) {
          _settings = SafetySettings.fromMap(localSettings);
        } else {
          // Create default settings for new users
          _settings = SafetySettings.defaultSettings(_userId!);
        }
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');

      // Fallback to local storage
      try {
        final localSettings = await StorageService.getSafetySettings();
        if (localSettings != null) {
          _settings = SafetySettings.fromMap(localSettings);
        } else {
          _settings = SafetySettings.defaultSettings(_userId!);
        }
      } catch (localError) {
        debugPrint('Error loading local settings: $localError');
        _settings = SafetySettings.defaultSettings(_userId!);
      }
    }
  }

  // Update authorized access setting
  Future<void> updateAuthorizedAccess(bool value) async {
    if (_settings == null) return;

    try {
      _isSaving = true;
      notifyListeners();

      // Update local state immediately for UI responsiveness
      _settings = _settings!.copyWith(
        authorizedAccess: value,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();

      // Save to database
      await _saveSettingsToDatabase();

      // Mark first time as complete
      if (_isFirstTime) {
        _isFirstTime = false;
        await StorageService.markFirstTimeComplete(_userId!);
      }
    } catch (e) {
      _error = 'Failed to update authorized access: ${e.toString()}';
      debugPrint(_error);

      // Revert local state on error
      _settings = _settings!.copyWith(
        authorizedAccess: !value,
        lastUpdated: DateTime.now(),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Update child detection setting
  Future<void> updateChildDetection(bool value) async {
    if (_settings == null) return;

    try {
      _isSaving = true;
      notifyListeners();

      // Update local state immediately
      _settings = _settings!.copyWith(
        childDetection: value,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();

      // Save to database
      await _saveSettingsToDatabase();

      // Mark first time as complete
      if (_isFirstTime) {
        _isFirstTime = false;
        await StorageService.markFirstTimeComplete(_userId!);
      }
    } catch (e) {
      _error = 'Failed to update child detection: ${e.toString()}';
      debugPrint(_error);

      // Revert local state on error
      _settings = _settings!.copyWith(
        childDetection: !value,
        lastUpdated: DateTime.now(),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Update pet detection setting
  Future<void> updatePetDetection(bool value) async {
    if (_settings == null) return;

    try {
      _isSaving = true;
      notifyListeners();

      // Update local state immediately
      _settings = _settings!.copyWith(
        petDetection: value,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();

      // Save to database
      await _saveSettingsToDatabase();

      // Mark first time as complete
      if (_isFirstTime) {
        _isFirstTime = false;
        await StorageService.markFirstTimeComplete(_userId!);
      }
    } catch (e) {
      _error = 'Failed to update pet detection: ${e.toString()}';
      debugPrint(_error);

      // Revert local state on error
      _settings = _settings!.copyWith(
        petDetection: !value,
        lastUpdated: DateTime.now(),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Save settings to database
  Future<void> _saveSettingsToDatabase() async {
    if (_settings == null || _userId == null) return;

    final response = await ApiService.updateNotificationSettings(
      userId: _userId!,
      childDetectionAlert: _settings!.childDetection,
      petDetectionAlert: _settings!.petDetection,
      unauthorizedAccess: _settings!.authorizedAccess,
    );

    if (response['success'] == true) {
      // Save to local storage as backup
      await StorageService.saveSafetySettings(_settings!.toMap());
      _error = null;
    } else {
      throw Exception(response['message'] ?? 'Failed to save settings');
    }
  }

  // Refresh settings from database
  Future<void> refreshSettings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _loadSettings();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error refreshing settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Initialize with user ID (call this after login)
  Future<void> initializeWithUserId(String userId) async {
    _userId = userId;
    await StorageService.saveUserId(userId);
    await _initializeSettings();
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset settings to default
  Future<void> resetToDefault() async {
    if (_userId == null) return;

    try {
      _isSaving = true;
      notifyListeners();

      _settings = SafetySettings.defaultSettings(_userId!);
      await _saveSettingsToDatabase();
    } catch (e) {
      _error = 'Failed to reset settings: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Logout - clear all data
  Future<void> logout() async {
    _settings = null;
    _userId = null;
    _isFirstTime = true;
    _error = null;
    _isLoading = false;
    _isSaving = false;

    await StorageService.clearAllData();
    notifyListeners();
  }
}
