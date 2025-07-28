import 'package:hive/hive.dart';

part 'permanent_user.g.dart';

@HiveType(typeId: 0)
class PermanentUser {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String carId;

  @HiveField(2)
  final String keypass;

  @HiveField(3)
  final String access; // "permanent"

  @HiveField(4)
  final String auth; //  "ble"

  PermanentUser({
    required this.name,
    required this.carId,
    required this.keypass,
    this.access = 'permanent',
    this.auth = 'ble',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'carId': carId,
      'keypass': keypass,
      'access': access,
      'auth': auth,
    };
  }

  Map<String, dynamic> toDeleteJson() {
    return {
      'name': name,
      'carId': carId,
      'keypass': keypass,
    };
  }

  factory PermanentUser.fromJson(Map<String, dynamic> json) {
    return PermanentUser(
      name: json['name'],
      carId: json['carId'],
      keypass: json['keypass'],
      access: json['access'] ?? 'permanent',
      auth: json['auth'] ?? 'ble',
    );
  }
}
