import 'package:hive/hive.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

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
  Document,
  @HiveField(4)
  Other
}

@HiveType(typeId: 5)
class Asset {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String relativePath; // Path relative to app's assets directory
  
  @HiveField(3)
  final AssetType type;
  
  @HiveField(4)
  final DateTime uploadedAt;

  @HiveField(5)
  final String? eventId;

  @HiveField(6)
  final String? actId;

  Asset({
    required this.id,
    required this.name,
    required this.relativePath,
    required this.type,
    required this.uploadedAt,
    this.eventId,
    this.actId,
  });

  static AssetType getTypeFromExtension(String fileName) {
    final ext = path.extension(fileName).toLowerCase();
    
    switch (ext) {
      case '.mp3':
      case '.wav':
      case '.m4a':
        return AssetType.Audio;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return AssetType.Image;
      case '.mp4':
      case '.mov':
      case '.avi':
        return AssetType.Video;
      case '.pdf':
      case '.doc':
      case '.docx':
      case '.txt':
        return AssetType.Document;
      default:
        return AssetType.Other;
    }
  }
}