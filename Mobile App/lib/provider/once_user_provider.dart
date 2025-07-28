import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../models/once_user.dart';
import '../models/once_user_local.dart';

class OnceUserProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _responseMessage;

  final List<OnceUser> _onceUsers = [];
  List<OnceUserLocal> _localUsers = [];
  Box<OnceUserLocal>? _localBox;

  bool get isLoading => _isLoading;
  String? get responseMessage => _responseMessage;

  List<OnceUser> get onceUsers => List.unmodifiable(_onceUsers);
  List<OnceUserLocal> get localUsers => _localUsers;

  /// upload data to Hive box
  Future<void> initLocalUsers() async {
    _localBox = Hive.box<OnceUserLocal>('onceUsers');
    _localUsers = _localBox!.values.toList();
    notifyListeners();
  }

  /// delete box on user locally
  Future<void> deleteUserLocally(int index) async {
    await _localBox?.deleteAt(index);
    _localUsers = _localBox!.values.toList();
    notifyListeners();
  }

  ///  add user to Hive and server
  Future<void> addOnceUser(OnceUser user) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net/once',
    );

    try {
      if (user.keypass != null) {
        // BLE:
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': user.name,
            'carId': user.carId,
            'auth': 'BLE',
            'keypass': user.keypass,
          }),
        );

        print(' [BLE] JSON Response status: ${response.statusCode}');
        print(' [BLE] JSON Response body: ${response.body}');

        if (response.statusCode == 201) {
          _responseMessage = "Once user added successfully";
          _onceUsers.add(user);

          //  add to Hive
          final localUser = OnceUserLocal(
            name: user.name,
            carId: user.carId,
            keypass: user.keypass,
            auth: user.keypass != null ? 'BLE' : 'Face',
            access: 'once',
          );

          await _localBox?.add(localUser);
          _localUsers = _localBox!.values.toList();
        } else {
          _responseMessage = "Failed to add user";
        }
      } else if (user.image != null) {
        // Face: send Multipart
        final request = http.MultipartRequest('POST', url);
        request.fields['name'] = user.name;
        request.fields['carId'] = user.carId;
        request.fields['auth'] = 'Face';

        final imageBytes = await user.image!.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'FaceImage',
          imageBytes,
          filename: 'face.jpg',
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print(' [Face] Multipart Response status: ${response.statusCode}');
        print(' [Face] Multipart Response body: ${response.body}');

        if (response.statusCode == 201) {
          _responseMessage = "Once user added successfully";
          _onceUsers.add(user);

          // add to  Hive
          final localUser = OnceUserLocal(
            name: user.name,
            carId: user.carId,
            keypass: user.keypass,
            auth: user.keypass != null ? 'BLE' : 'Face',
            access: 'once',
          );
          await _localBox?.add(localUser);
          _localUsers = _localBox!.values.toList();
        } else {
          _responseMessage = "Failed to add user";
        }
      } else {
        _responseMessage = "Must provide either keypass or image.";
      }
    } catch (e) {
      _responseMessage = "Failed to add user";
      print('❌ Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
