import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../providers/assets_provider.dart';
import 'asset_player_screen.dart';

class AssetListScreen extends StatelessWidget {
  const AssetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AssetType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assets'),
          bottom: TabBar(
            tabs: AssetType.values.map((type) => Tab(
              text: type.toString().split('.').last,
            )).toList(),
          ),
        ),
        body: TabBarView(
          children: AssetType.values.map((type) => _AssetTypeList(type)).toList(),
        ),
      ),
    );
  }
}

class _AssetTypeList extends StatelessWidget {
  final AssetType assetType;

  const _AssetTypeList(this.assetType);

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetsProvider>(
      builder: (ctx, provider, _) {
        final assets = provider.getAssetsByType(assetType);
        return ListView.builder(
          itemCount: assets.length,
          itemBuilder: (ctx, i) => ListTile(
            leading: Icon(_getIconForType(assetType)),
            title: Text(assets[i].name),
            subtitle: Text(assets[i].description ?? ''),
            onTap: () {
              if (assetType == AssetType.Audio) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AssetPlayerScreen(asset: assets[i]),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  IconData _getIconForType(AssetType type) {
    switch (type) {
      case AssetType.Audio:
        return Icons.audio_file;
      case AssetType.Image:
        return Icons.image;
      case AssetType.Video:
        return Icons.video_file;
      case AssetType.Document:
        return Icons.description;
    }
  }
}
