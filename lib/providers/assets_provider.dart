import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/asset.dart';

class AssetsProvider with ChangeNotifier {
  List<Asset> _assets = [];
  
  List<Asset> get assets => [..._assets];
  
  List<Asset> getAssetsByType(AssetType type) {
    return _assets.where((asset) => asset.type == type).toList();
  }

  Future<void> loadAssets() async {
    final box = Hive.box<Asset>('assets');
    _assets = box.values.toList();
    notifyListeners();
  }

  Future<void> addAsset(Asset asset) async {
    final box = Hive.box<Asset>('assets');
    await box.put(asset.id, asset);
    await loadAssets();
  }

  Future<void> deleteAsset(String id) async {
    final box = Hive.box<Asset>('assets');
    await box.delete(id);
    await loadAssets();
  }

  Asset? getAssetById(String id) {
    try {
      return _assets.firstWhere((asset) => asset.id == id);
    } catch (e) {
      return null;
    }
  }
}
