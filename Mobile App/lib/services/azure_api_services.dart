import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class AzureApiService {
  static const String baseUrl =
      'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net';

  static const String registerEndpoint = '$baseUrl/register';
  static const String loginEndpoint = '$baseUrl/login';
  static const String validateTokenEndpoint = '$baseUrl/validate-token';
  static const String updateProfileEndpoint = '$baseUrl/update-profile';

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Register a new user with Azure backend using form-data
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    File? profileImage,
  }) async {
    try {
      print('Sending registration request to: $registerEndpoint');

      // Create multipart request for form-data
      var request = http.MultipartRequest('POST', Uri.parse(registerEndpoint));

      // Add text fields
      request.fields['Name'] = name;
      request.fields['Email'] = email;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['Password'] = password;

      // Add profile image if provided
      if (profileImage != null) {
        // Validate file
        if (!profileImage.existsSync()) {
          throw Exception('Image file does not exist');
        }

        final fileSize = profileImage.lengthSync();
        if (fileSize == 0) {
          throw Exception('Image file is empty');
        }

        if (fileSize > 5 * 1024 * 1024) {
          throw Exception('Image file is too large (max 5MB)');
        }

        final mimeType = lookupMimeType(profileImage.path) ?? 'image/jpeg';
        if (!mimeType.startsWith('image/')) {
          throw Exception('Please select a valid image file');
        }

        // Add the profile image file
        request.files.add(
          await http.MultipartFile.fromPath(
            'ProfileImage', // This must match your backend field name
            profileImage.path,
            contentType: MediaType.parse(mimeType),
          ),
        );

        print(
            'Added profile image: ${basename(profileImage.path)}, size: $fileSize bytes');
      }

      // Set headers for multipart request
      request.headers.addAll({
        'Accept': 'application/json',
      });

      print('Request fields: ${request.fields}');
      print(
          'Request files: ${request.files.map((f) => '${f.field}: ${f.filename!}')}');

      // Send the request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Registration request timed out');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = _safeJsonDecode(response.body);

        return {
          'success': true,
          'user': responseData['user'] ??
              {
                'Name': name,
                'Email': email,
                'phoneNumber': phoneNumber,
                'ProfileImage': responseData['ProfileImage'],
              },
          'token': responseData['token'],
          'message': responseData['message'] ?? 'User registered successfully',
        };
      } else if (response.statusCode == 400) {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ??
            'Bad request - Please check your input data');
      } else if (response.statusCode == 409) {
        throw Exception('An account with this email already exists');
      } else if (response.statusCode == 422) {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid input data provided');
      } else if (response.statusCode == 500) {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Server error occurred');
      } else {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ??
            'Registration failed: ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception(
          'No internet connection. Please check your network and try again.');
    } on FormatException catch (e) {
      print('JSON Format error: $e');
      throw Exception('Invalid response format');
    } on http.ClientException {
      throw Exception(
          'Network error. Please check your connection and try again.');
    } catch (e) {
      print('Registration error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Registration failed. Please try again.');
    }
  }

  /// Register user without profile image (fallback method)
  static Future<Map<String, dynamic>> registerUserWithoutImage({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      print('Sending registration request (no image) to: $registerEndpoint');

      // Try with form-data but no file
      var request = http.MultipartRequest('POST', Uri.parse(registerEndpoint));

      request.fields['Name'] = name;
      request.fields['Email'] = email;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['Password'] = password;

      request.headers.addAll({
        'Accept': 'application/json',
      });

      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
          );

      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = _safeJsonDecode(response.body);
        return {
          'success': true,
          'user': responseData['user'],
          'token': responseData['token'],
          'message': responseData['message'] ?? 'User registered successfully',
        };
      } else {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Registration without image error: $e');
      rethrow;
    }
  }

  /// Login user with enhanced error handling
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'Email': email,
        'Password': password,
      };

      print('Sending login request to: $loginEndpoint');

      final response = await http
          .post(
            Uri.parse(loginEndpoint),
            headers: headers,
            body: jsonEncode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = _safeJsonDecode(response.body);

        Map<String, dynamic> userData;
        if (responseData.containsKey('user')) {
          userData = responseData['user'];
        } else {
          userData = {
            'id': responseData['id'],
            'Name': responseData['Name'],
            'Email': responseData['Email'],
            'phoneNumber': responseData['phoneNumber'],
            'ProfileImage': responseData['ProfileImage'],
          };
        }

        return {
          'success': true,
          'user': userData,
          'token': responseData['token'],
          'message': responseData['message'] ?? 'Login successful',
        };
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 404) {
        throw Exception('No account found with this email address');
      } else {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Validate authentication token
  static Future<Map<String, dynamic>> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse(validateTokenEndpoint),
        headers: {
          ...headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false};
      }
    } catch (e) {
      print('Token validation error: $e');
      return {'success': false};
    }
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    required String token,
    String? name,
    String? phoneNumber,
    File? profileImage,
  }) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse(updateProfileEndpoint));

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add text fields if provided
      if (name != null) request.fields['Name'] = name;
      if (phoneNumber != null) request.fields['phoneNumber'] = phoneNumber;

      // Add profile image if provided
      if (profileImage != null) {
        final mimeType = lookupMimeType(profileImage.path) ?? 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath(
            'ProfileImage',
            profileImage.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = _safeJsonDecode(response.body);
        return {
          'success': true,
          'user': responseData['user'],
        };
      } else {
        final errorData = _safeJsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Profile update failed');
      }
    } catch (e) {
      print('Profile update error: $e');
      rethrow;
    }
  }

  /// Safe JSON decode helper
  static Map<String, dynamic> _safeJsonDecode(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('JSON decode error: $e');
      return {'message': 'Invalid response format'};
    }
  }
}
