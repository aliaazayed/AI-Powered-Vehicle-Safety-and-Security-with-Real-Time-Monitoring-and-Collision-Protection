import 'package:hive/hive.dart';

part 'once_user_local.g.dart';

@HiveType(typeId: 2)
class OnceUserLocal {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String carId;

  @HiveField(2)
  final String? keypass;

  @HiveField(3)
  final String auth;

  @HiveField(4)
  final String access;

// data save without image
  OnceUserLocal({
    required this.name,
    required this.carId,
    required this.auth,
    required this.access,
    this.keypass,
  });
}
