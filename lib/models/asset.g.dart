// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetAdapter extends TypeAdapter<Asset> {
  @override
  final int typeId = 4;

  @override
  Asset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Asset(
      id: fields[0] as String,
      type: fields[1] as AssetType,
      downloadUrl: fields[2] as String,
      localPath: fields[3] as String?,
      actId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Asset obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.downloadUrl)
      ..writeByte(3)
      ..write(obj.localPath)
      ..writeByte(4)
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
  final int typeId = 10;

  @override
  AssetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AssetType.Song;
      case 1:
        return AssetType.Poster;
      case 2:
        return AssetType.Prop;
      default:
        return AssetType.Song;
    }
  }

  @override
  void write(BinaryWriter writer, AssetType obj) {
    switch (obj) {
      case AssetType.Song:
        writer.writeByte(0);
        break;
      case AssetType.Poster:
        writer.writeByte(1);
        break;
      case AssetType.Prop:
        writer.writeByte(2);
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
