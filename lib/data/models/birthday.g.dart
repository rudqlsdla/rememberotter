// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birthday.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BirthdayAdapter extends TypeAdapter<Birthday> {
  @override
  final int typeId = 0;

  @override
  Birthday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Birthday(
      id: fields[0] as String,
      name: fields[1] as String,
      birthDate: fields[2] as DateTime,
      memo: fields[3] as String?,
      profileImage: fields[4] as String?,
      isLunarCalendar: fields[5] as bool,
      notificationEnabled: fields[6] as bool,
      notificationDaysBefore: fields[7] as int,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Birthday obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.memo)
      ..writeByte(4)
      ..write(obj.profileImage)
      ..writeByte(5)
      ..write(obj.isLunarCalendar)
      ..writeByte(6)
      ..write(obj.notificationEnabled)
      ..writeByte(7)
      ..write(obj.notificationDaysBefore)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirthdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
