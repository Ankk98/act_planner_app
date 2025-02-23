// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'act.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActAdapter extends TypeAdapter<Act> {
  @override
  final int typeId = 3;

  @override
  Act read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Act(
      id: fields[0] as String,
      eventId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      startTime: fields[4] as DateTime,
      duration: fields[5] as Duration,
      sequenceId: fields[6] as int,
      isApproved: fields[7] as bool,
      participantIds: (fields[8] as List).cast<String>(),
      assets: (fields[9] as List).cast<Asset>(),
      createdBy: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Act obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.sequenceId)
      ..writeByte(7)
      ..write(obj.isApproved)
      ..writeByte(8)
      ..write(obj.participantIds)
      ..writeByte(9)
      ..write(obj.assets)
      ..writeByte(10)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
