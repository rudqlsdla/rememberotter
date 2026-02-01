// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiftAdapter extends TypeAdapter<Gift> {
  @override
  final int typeId = 1;

  @override
  Gift read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gift(
      id: fields[0] as String,
      birthdayId: fields[1] as String,
      year: fields[2] as int,
      given: fields[3] as bool,
      received: fields[4] as bool,
      givenGiftName: fields[5] as String?,
      receivedGiftName: fields[6] as String?,
      memo: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Gift obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.birthdayId)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.given)
      ..writeByte(4)
      ..write(obj.received)
      ..writeByte(5)
      ..write(obj.givenGiftName)
      ..writeByte(6)
      ..write(obj.receivedGiftName)
      ..writeByte(7)
      ..write(obj.memo)
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
      other is GiftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
