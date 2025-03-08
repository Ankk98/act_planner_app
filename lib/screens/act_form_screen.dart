import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/act.dart';
import '../models/asset.dart';
import '../providers/acts_provider.dart';
import '../providers/assets_provider.dart';

class ActFormScreen extends StatefulWidget {
  final String eventId;
  final Act? act;

  const ActFormScreen({super.key, required this.eventId, this.act});

  @override
  State<ActFormScreen> createState() => _ActFormScreenState();
}

class _ActFormScreenState extends State<ActFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  DateTime? _startTime;
  List<Asset> _selectedAssets = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.act?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.act?.description ?? '',
    );
    _durationController = TextEditingController(
      text: widget.act?.duration.inMinutes.toString() ?? '30',
    );
    _startTime = widget.act?.startTime ?? DateTime.now();
    _selectedAssets = widget.act?.assets.toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime ?? DateTime.now()),
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        _startTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveAct() {
    if (!_formKey.currentState!.validate()) return;

    final actsProvider = Provider.of<ActsProvider>(context, listen: false);
    final duration = Duration(minutes: int.parse(_durationController.text));

    final act = Act(
      id: widget.act?.id ?? const Uuid().v4(),
      eventId: widget.eventId,
      name: _nameController.text,
      description: _descriptionController.text,
      startTime: _startTime!,
      duration: duration,
      sequenceId: widget.act?.sequenceId ?? actsProvider.acts.length + 1,
      isApproved: widget.act?.isApproved ?? false,
      participantIds: widget.act?.participantIds ?? [],
      assets: _selectedAssets,
      createdBy: 'current_user_id', // Replace with actual user ID
    );

    if (widget.act == null) {
      actsProvider.addAct(act);
    } else {
      actsProvider.updateAct(act);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.act == null ? 'Add Act' : 'Edit Act'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveAct),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Act Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _selectStartTime,
                    child: Text(
                      'Start Time: ${_startTime?.hour ?? 00}:${_startTime?.minute.toString().padLeft(2, '0') ?? '00'}',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (minutes)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter duration';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<AssetsProvider>(
              builder: (context, assetsProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Assets:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    if (widget.act != null && widget.act!.assets.isNotEmpty)
                      Column(
                        children:
                            widget.act!.assets
                                .map(
                                  (asset) => ListTile(
                                    leading: _getAssetIcon(asset.type),
                                    title: Text(asset.name),
                                    subtitle: Text(
                                      asset.type.toString().split('.').last,
                                    ),
                                  ),
                                )
                                .toList(),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No assets attached to this act'),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAssetIcon(AssetType type) {
    switch (type) {
      case AssetType.Audio:
        return const Icon(Icons.audiotrack);
      case AssetType.Image:
        return const Icon(Icons.image);
      case AssetType.Video:
        return const Icon(Icons.videocam);
      case AssetType.Document:
        return const Icon(Icons.description);
      default:
        return const Icon(Icons.attachment);
    }
  }
}
