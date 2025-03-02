import 'package:flutter/material.dart';
import '../models/act.dart';

class ActForm extends StatefulWidget {
  final Act? act;
  final String eventId;

  const ActForm({
    super.key,
    this.act,
    required this.eventId,
  });

  @override
  State<ActForm> createState() => _ActFormState();
}

class _ActFormState extends State<ActForm> {
  final _formKey = GlobalKey<FormState>();
  // Add other necessary controllers and variables here
  
  Widget _buildAssetList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assets', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (widget.act != null && widget.act!.assets.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.act!.assets.length,
            itemBuilder: (context, index) {
              final asset = widget.act!.assets[index];
              return ListTile(
                title: Text(asset.name),
                subtitle: Text(asset.type.toString().split('.').last),
              );
            },
          )
        else
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No assets attached'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add other form fields here
          _buildAssetList(),
          // Add more form fields if needed
        ],
      ),
    );
  }
}
