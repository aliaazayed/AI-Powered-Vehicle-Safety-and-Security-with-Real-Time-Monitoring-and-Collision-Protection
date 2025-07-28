import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net';
  static const String loginEndpoint = '/login';
  static const String notificationsEndpoint = '/notifications';
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Login method (keeping your existing implementation)
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    int retryCount = 0,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$loginEndpoint');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Connection': 'keep-alive',
            },
            body: json.encode({
              'Email': email,
              'Password': password,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['message'] == 'login successful') {
          return {
            'success': true,
            'data': responseData['user'],
            'message': 'Login successful'
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Login failed'
          };
        }
      } else if (response.statusCode == 401) {
        try {
          final responseData = json.decode(response.body);
          return {
            'success': false,
            'message': responseData['message'] ?? 'Invalid email or password'
          };
        } catch (e) {
          return {'success': false, 'message': 'Invalid email or password'};
        }
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message':
              'Account not found. Please check your credentials or sign up.'
        };
      } else if (response.statusCode >= 500) {
        return {
          'success': false,
          'message': 'Server error. Please try again later.',
          'serverError': true,
        };
      } else {
        try {
          final responseData = json.decode(response.body);
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Login failed. Please try again.'
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Login failed. Please try again.'
          };
        }
      }
    } on SocketException catch (_) {
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));
        return signIn(
            email: email, password: password, retryCount: retryCount + 1);
      }
      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'networkError': true,
      };
    } on TimeoutException catch (_) {
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));
        return signIn(
            email: email, password: password, retryCount: retryCount + 1);
      }
      return {
        'success': false,
        'message': 'Connection timeout. Please try again.',
        'networkError': true,
      };
    } on HttpException catch (_) {
      return {
        'success': false,
        'message': 'Server connection failed. Please try again later.',
        'networkError': true,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
        'error': e.toString(),
      };
    }
  }

  // Get user's notification settings from database
  static Future<Map<String, dynamic>> getUserNotificationSettings(
      String userId) async {
    try {
      final url = Uri.parse('$baseUrl$notificationsEndpoint/$userId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else if (response.statusCode == 404) {
        // User hasn't set preferences yet, return default (all false)
        return {
          'success': true,
          'data': {
            'userId': userId,
            'childDetectionAlert': false,
            'petDetectionAlert': false,
            'unauthorizedAccess': false,
          },
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load notification settings',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error loading notification settings: ${e.toString()}',
      };
    }
  }

  // Update user's notification settings in database
  static Future<Map<String, dynamic>> updateNotificationSettings({
    required String userId,
    required bool childDetectionAlert,
    required bool petDetectionAlert,
    required bool unauthorizedAccess,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$notificationsEndpoint/$userId');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'childDetectionAlert': childDetectionAlert,
              'petDetectionAlert': petDetectionAlert,
              'unauthorizedAccess': unauthorizedAccess,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Notification settings updated successfully',
        };
      } else {
        try {
          final responseData = json.decode(response.body);
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to update settings',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to update notification settings',
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating notification settings: ${e.toString()}',
      };
    }
  }
}
