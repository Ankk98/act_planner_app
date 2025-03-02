import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assets_provider.dart';
import '../models/asset.dart';

class AssetSelectorDialog extends StatefulWidget {
  final Function(Asset) onAssetSelected;
  final String? eventId;
  final String? actId;

  const AssetSelectorDialog({
    super.key,
    required this.onAssetSelected,
    this.eventId,
    this.actId,
  });

  @override
  State<AssetSelectorDialog> createState() => _AssetSelectorDialogState();
}

class _AssetSelectorDialogState extends State<AssetSelectorDialog> {
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
    return Dialog(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Asset',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Consumer<AssetsProvider>(
              builder: (context, assetsProvider, child) {
                final assets = assetsProvider.assets;
                
                if (assets.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No assets available'),
                    ),
                  );
                }

                return Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      return ListTile(
                        leading: _buildAssetIcon(asset.type),
                        title: Text(asset.name),
                        subtitle: Text(asset.type.toString().split('.').last),
                        onTap: () {
                          widget.onAssetSelected(asset);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
