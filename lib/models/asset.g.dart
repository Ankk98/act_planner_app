// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetAdapter extends TypeAdapter<Asset> {
  @override
  final int typeId = 5;

  @override
  Asset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Asset(
      id: fields[0] as String,
      name: fields[1] as String,
      relativePath: fields[2] as String,
      type: fields[3] as AssetType,
      uploadedAt: fields[4] as DateTime,
      eventId: fields[5] as String?,
      actId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Asset obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.relativePath)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.uploadedAt)
      ..writeByte(5)
      ..write(obj.eventId)
      ..writeByte(6)
      ..write(obj.actId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssetTypeAdapter extends TypeAdapter<AssetType> {
  @override
  final int typeId = 4;

  @override
  AssetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AssetType.Audio;
      case 1:
        return AssetType.Image;
      case 2:
        return AssetType.Video;
      case 3:
        return AssetType.Document;
      case 4:
        return AssetType.Other;
      default:
        return AssetType.Audio;
    }
  }

  @override
  void write(BinaryWriter writer, AssetType obj) {
    switch (obj) {
      case AssetType.Audio:
        writer.writeByte(0);
        break;
      case AssetType.Image:
        writer.writeByte(1);
        break;
      case AssetType.Video:
        writer.writeByte(2);
        break;
      case AssetType.Document:
        writer.writeByte(3);
        break;
      case AssetType.Other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
