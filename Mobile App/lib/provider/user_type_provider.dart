import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTypeProvider with ChangeNotifier {
  String _userType = 'unknown';

  String get userType => _userType;

  bool get isOwner => _userType == 'owner';
  bool get isPermanent => _userType == 'permanent';
  bool get isGuest => _userType == 'guest';

  Future<void> loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('userType') ?? 'unknown';
    notifyListeners();
  }

  Future<void> setUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', type);
    _userType = type;
    notifyListeners();
  }

  Future<void> clearUserType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType');
    _userType = 'unknown';
    notifyListeners();
  }
}
