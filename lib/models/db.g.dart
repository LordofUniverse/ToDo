// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataBaseAdapter extends TypeAdapter<DataBase> {
  @override
  final int typeId = 0;

  @override
  DataBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataBase(
      title: fields[0] as String,
      check: fields[1] as bool,
      edited: fields[2] as bool,
      level: fields[3] as int,
    )
      ..year = fields[4] as int
      ..month = fields[5] as int
      ..date = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, DataBase obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.check)
      ..writeByte(2)
      ..write(obj.edited)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.year)
      ..writeByte(5)
      ..write(obj.month)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataBaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
