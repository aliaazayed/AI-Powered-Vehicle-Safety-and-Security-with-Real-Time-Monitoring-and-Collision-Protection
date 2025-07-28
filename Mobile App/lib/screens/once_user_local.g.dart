// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'once_user_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnceUserLocalAdapter extends TypeAdapter<OnceUserLocal> {
  @override
  final int typeId = 2;

  @override
  OnceUserLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnceUserLocal(
      name: fields[0] as String,
      carId: fields[1] as String,
      auth: fields[3] as String,
      access: fields[4] as String,
      keypass: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OnceUserLocal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.carId)
      ..writeByte(2)
      ..write(obj.keypass)
      ..writeByte(3)
      ..write(obj.auth)
      ..writeByte(4)
      ..write(obj.access);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnceUserLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
