// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final int typeId = 2;

  @override
  Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contact(
      id: fields[0] as String,
      eventId: fields[1] as String,
      userId: fields[2] as String,
      role: fields[3] as Role,
      name: fields[5] as String,
      phone: fields[6] as String,
      email: fields[7] as String,
      additionalInfo: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer
      ..writeByte(8)  // Update to reflect total number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.additionalInfo)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 9;

  @override
  Role read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Role.Admin;
      case 1:
        return Role.Participant;
      case 2:
        return Role.Anchor;
      case 3:
        return Role.Audience;
      default:
        return Role.Admin;
    }
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    switch (obj) {
      case Role.Admin:
        writer.writeByte(0);
        break;
      case Role.Participant:
        writer.writeByte(1);
        break;
      case Role.Anchor:
        writer.writeByte(2);
        break;
      case Role.Audience:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
