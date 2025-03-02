import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/act.dart';
import '../models/asset.dart';
import '../providers/acts_provider.dart';
import '../providers/assets_provider.dart';
import '../services/asset_service.dart';
import 'act_form_screen.dart';

class ActDetailsScreen extends StatelessWidget {
  final Act act;

  const ActDetailsScreen({
    super.key,
    required this.act,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}';
    }
    return '$minutes min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Act Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActFormScreen(
                    eventId: act.eventId,
                    act: act,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ActsProvider>(
        builder: (context, actsProvider, child) {
          // Get the latest version of the act
          final currentAct = actsProvider.acts.firstWhere((a) => a.id == act.id);
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentAct.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentAct.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timing Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text('Start Time: ${currentAct.startTime.hour}:${currentAct.startTime.minute.toString().padLeft(2, '0')}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.timelapse),
                        title: Text('Duration: ${_formatDuration(currentAct.duration)}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.format_list_numbered),
                        title: Text('Sequence: ${currentAct.sequenceId}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assets',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (currentAct.assets.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No assets added yet'),
                        )
                      else
                        ...currentAct.assets.map((asset) => ListTile(
                          leading: Icon(_getAssetIcon(asset.type)),
                          title: Text(asset.name),
                          subtitle: Text(asset.type.toString().split('.').last),
                        )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getAssetIcon(AssetType type) {
    switch (type) {
      case AssetType.Audio:
        return Icons.audiotrack;
      case AssetType.Image:
        return Icons.image;
      case AssetType.Video:
        return Icons.videocam;
      case AssetType.Document:
        return Icons.description;
      default:
        return Icons.attachment;
    }
  }
} 