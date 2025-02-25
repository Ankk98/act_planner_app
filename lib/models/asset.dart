import 'package:hive/hive.dart';

part 'asset.g.dart';

@HiveType(typeId: 4)
enum AssetType {
  @HiveField(0)
  Audio,
  @HiveField(1)
  Image,
  @HiveField(2)
  Video,
  @HiveField(3)
  Document
}

@HiveType(typeId: 5)
class Asset {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String path;
  
  @HiveField(3)
  final AssetType type;
  
  @HiveField(4)
  final String? description;
  
  @HiveField(5)
  final DateTime uploadedAt;

  Asset({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    this.description,
    required this.uploadedAt,
  });
}