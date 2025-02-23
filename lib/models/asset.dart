import 'package:hive/hive.dart';

part 'asset.g.dart'; // Generated file

@HiveType(typeId: 4)
class Asset {
  @HiveField(0) String id;
  @HiveField(1) AssetType type;
  @HiveField(2) String downloadUrl;
  @HiveField(3) String? localPath;
  @HiveField(4) String actId;

  Asset({
    required this.id,
    required this.type,
    required this.downloadUrl,
    this.localPath,
    required this.actId,
  });
}

@HiveType(typeId: 10)
enum AssetType {
  @HiveField(0)
  Song,
  @HiveField(1)
  Poster,
  @HiveField(2)
  Prop,
}