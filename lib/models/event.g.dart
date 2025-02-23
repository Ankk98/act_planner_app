// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      date: fields[3] as DateTime,
      venue: fields[4] as String,
      startTime: fields[5] as DateTime,
      actIds: (fields[6] as List).cast<String>(),
      contactIds: (fields[7] as List).cast<String>(),
      type: fields[8] as EventType,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.venue)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.actIds)
      ..writeByte(7)
      ..write(obj.contactIds)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 8;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.Wedding;
      case 1:
        return EventType.SchoolAnnualDay;
      case 2:
        return EventType.Society;
      default:
        return EventType.Wedding;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.Wedding:
        writer.writeByte(0);
        break;
      case EventType.SchoolAnnualDay:
        writer.writeByte(1);
        break;
      case EventType.Society:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
