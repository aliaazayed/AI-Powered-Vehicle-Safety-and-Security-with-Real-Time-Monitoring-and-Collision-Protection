import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:test2zfroma/models/permanent_user.dart';

class PermanentUserProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _responseMessage;

  late Box<PermanentUser> _box;

  List<PermanentUser> _permanentUsers = [];

  bool get isLoading => _isLoading;
  String? get responseMessage => _responseMessage;
  List<PermanentUser> get permanentUsers => _permanentUsers;

  ///  Load data from Hive at initialization
  Future<void> loadFromHive() async {
    _box = Hive.box<PermanentUser>('permanentUsers');
    _permanentUsers = _box.values.toList();
    notifyListeners();
  }

  ///  Clear the response message after it's shown
  void clearResponse() {
    _responseMessage = null;
    notifyListeners();
  }

  ///  Remove a user locally by index
  void removeUserAt(int index) {
    _box.deleteAt(index);
    _permanentUsers.removeAt(index);
    notifyListeners();
  }

  ///  Add a permanent user with API submission and local storage
  Future<void> addPermanentUser(PermanentUser user) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net/permanent',
    );

    try {
      final requestBody = json.encode(user.toJson());
      print('📤 Sent data: $requestBody');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response body: ${response.body}');

      if (response.statusCode == 201) {
        _responseMessage = null;

        // Save to Hive + update list
        await _box.add(user);
        _permanentUsers = _box.values.toList();
        notifyListeners();

        print('✅ Saved to Hive: ${user.name}');
      } else {
        _responseMessage =
        "❌ Failed to add user: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      _responseMessage = "❌ Error: $e";
      print('❌ Exception during HTTP POST: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///  Delete a user from Hive only (local deletion)
  void deleteUserLocally(int index) {
    _box.deleteAt(index);
    _permanentUsers = _box.values.toList();
    notifyListeners();
  }
}
