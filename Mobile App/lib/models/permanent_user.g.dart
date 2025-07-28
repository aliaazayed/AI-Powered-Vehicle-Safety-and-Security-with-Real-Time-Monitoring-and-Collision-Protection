// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permanent_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermanentUserAdapter extends TypeAdapter<PermanentUser> {
  @override
  final int typeId = 0;

  @override
  PermanentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PermanentUser(
      name: fields[0] as String,
      carId: fields[1] as String,
      keypass: fields[2] as String,
      access: fields[3] as String,
      auth: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PermanentUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.carId)
      ..writeByte(2)
      ..write(obj.keypass)
      ..writeByte(3)
      ..write(obj.access)
      ..writeByte(4)
      ..write(obj.auth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermanentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
