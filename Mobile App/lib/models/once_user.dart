import 'dart:io';

import 'package:test2zfroma/models/once_user_local.dart';

class OnceUser {
  final String name;
  final String carId;
  final String? keypass;
  final File? image;
  final String? imageUrl;

  OnceUser({
    required this.name,
    required this.carId,
    this.keypass,
    this.image,
    this.imageUrl,
  });

  String get auth => keypass != null ? 'BLE' : 'Face';

  Map<String, dynamic> toJson() {
    throw UnimplementedError(
        'Don\'t use toJson for this class. Use MultipartRequest instead.');
  }

  factory OnceUser.fromJson(Map<String, dynamic> json) {
    return OnceUser(
      name: json['name'],
      carId: json['carId'],
      keypass: json['key'],
      image: null,
      imageUrl: json['FaceImage'],
    );
  }
  factory OnceUser.fromLocal(OnceUserLocal local) {
    return OnceUser(
      name: local.name,
      carId: local.carId,
      keypass: local.keypass,
    );
  }
}
