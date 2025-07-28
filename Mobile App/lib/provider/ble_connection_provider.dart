import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleConnectionProvider extends ChangeNotifier {
  bool _isConnected = false;
  String? _deviceName;
  String? _deviceId;

  QualifiedCharacteristic? _keypassCharacteristic;
  QualifiedCharacteristic? _doorCharacteristic;
  QualifiedCharacteristic? _trunkCharacteristic;
  String? _keypass;

  // Getters
  bool get isConnected => _isConnected;
  String? get deviceName => _deviceName;
  String? get deviceId => _deviceId;
  QualifiedCharacteristic? get keypassCharacteristic => _keypassCharacteristic;
  QualifiedCharacteristic? get doorCharacteristic => _doorCharacteristic;
  QualifiedCharacteristic? get trunkCharacteristic => _trunkCharacteristic;
  String? get keypass => _keypass;
  bool _hasSentKeypass = false;

  bool get hasSentKeypass => _hasSentKeypass;


  void markKeypassSent() {
    _hasSentKeypass = true;
    notifyListeners();
  }

  void resetKeypassSent() {
    _hasSentKeypass = false;
  }


  /// Update connection info including all characteristics
  void updateConnection({
    required bool connected,
    String? name,
    String? id,
    QualifiedCharacteristic? keypassChar,
    QualifiedCharacteristic? doorChar,
    QualifiedCharacteristic? trunkChar,
    String? keypass,
  }) {
    _isConnected = connected;
    _deviceName = name;
    _deviceId = id;
    _keypassCharacteristic = keypassChar;
    _doorCharacteristic = doorChar;
    _trunkCharacteristic = trunkChar;
    _keypass = keypass;
    notifyListeners();
  }

  /// Update only the stored keypass value
  void updateKeypass(String keypass) {
    _keypass = keypass;
    notifyListeners();
  }


  /// Disconnect and clear all
  void disconnect() {
    _isConnected = false;
    _deviceName = null;
    _deviceId = null;
    _keypassCharacteristic = null;
    _doorCharacteristic = null;
    _trunkCharacteristic = null;
    _keypass = null;
    notifyListeners();
    resetKeypassSent();

  }
}
