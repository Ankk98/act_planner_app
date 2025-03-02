import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../providers/assets_provider.dart';
import '../services/asset_service.dart';

class AssetListScreen extends StatefulWidget {
  final String? eventId;
  final String? actId;

  const AssetListScreen({
    super.key,
    this.eventId,
    this.actId,
  });

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  late AssetService _assetService;

  @override
  void initState() {
    super.initState();
    _assetService = AssetService(
      assetsProvider: Provider.of<AssetsProvider>(context, listen: false),
    );
  }

  Widget _buildAssetIcon(AssetType type) {
    IconData iconData;
    switch (type) {
      case AssetType.Audio:
        iconData = Icons.audio_file;
        break;
      case AssetType.Image:
        iconData = Icons.image;
        break;
      case AssetType.Video:
        iconData = Icons.video_file;
        break;
      case AssetType.Document:
        iconData = Icons.description;
        break;
      case AssetType.Other:
        iconData = Icons.insert_drive_file;
        break;
    }
    return Icon(iconData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: Consumer<AssetsProvider>(
        builder: (context, assetsProvider, child) {
          final assets = assetsProvider.assets.where((asset) {
            if (widget.actId != null) {
              return asset.actId == widget.actId;
            }
            if (widget.eventId != null) {
              return asset.eventId == widget.eventId;
            }
            return true;
          }).toList();

          if (assets.isEmpty) {
            return const Center(
              child: Text('No assets found'),
            );
          }

          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return ListTile(
                leading: _buildAssetIcon(asset.type),
                title: Text(asset.name),
                subtitle: Text(
                  'Uploaded: ${asset.uploadedAt.toString().split('.')[0]}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Asset'),
                        content: const Text(
                          'Are you sure you want to delete this asset?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(ctx, false),
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () => Navigator.pop(ctx, true),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await assetsProvider.deleteAsset(asset.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
