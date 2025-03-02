import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/asset.dart';
import '../providers/assets_provider.dart';

class AssetService {
  final AssetsProvider assetsProvider;

  AssetService({required this.assetsProvider});

  Future<String> getAssetsDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access external storage');
      }
      debugPrint('External storage directory: ${directory.path}');
      
      final assetsDir = Directory(path.join(directory.path, 'assets'));
      if (!await assetsDir.exists()) {
        await assetsDir.create(recursive: true);
      }
      
      return assetsDir.path;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(appDir.path, 'assets');
    }
  }

  Future<String> getEventDirectory(String eventId) async {
    final assetsDir = await getAssetsDirectory();
    return path.join(assetsDir, 'events', eventId);
  }

  Future<String> getActDirectory(String eventId, String actId) async {
    final eventDir = await getEventDirectory(eventId);
    return path.join(eventDir, 'acts', actId);
  }

  Future<void> ensureDirectoryExists(String dirPath) async {
    final directory = Directory(dirPath);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
  }

  Future<Asset?> getAssetById(String id) async {
    return assetsProvider.getAssetById(id);
  }

  // Simplified method to get path info
  Future<String> getAccessibleFilePathInfo() async {
    final assetsDir = await getAssetsDirectory();
    return 'Files are stored in:\n$assetsDir';
  }

  // Get a short version of the path info
  Future<String> getShortPathInfo() async {
    if (Platform.isAndroid) {
      return 'App storage/assets';
    } else {
      final assetsDir = await getAssetsDirectory();
      return assetsDir;
    }
  }

  // Print the base assets directory path for debugging
  Future<void> printAssetsDirectoryPath() async {
    final assetsDir = await getAssetsDirectory();
    debugPrint('Assets directory location: $assetsDir');
  }
}
