import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/act.dart';
import '../providers/acts_provider.dart';

class ActFormScreen extends StatefulWidget {
  final String eventId;
  final Act? act;

  const ActFormScreen({required this.eventId, this.act, super.key});

  @override
  _ActFormScreenState createState() => _ActFormScreenState();
}

class _ActFormScreenState extends State<ActFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late DateTime _startTime;
  late Duration _duration;
  late int _sequenceId;

  @override
  void initState() {
    super.initState();
    _name = widget.act?.name ?? '';
    _description = widget.act?.description ?? '';
    _startTime = widget.act?.startTime ?? DateTime.now();
    _duration = widget.act?.duration ?? Duration(minutes: 15);
    _sequenceId = widget.act?.sequenceId ?? 1;
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final act = Act(
        id: widget.act?.id ?? DateTime.now().toString(),
        eventId: widget.eventId,
        name: _name,
        description: _description,
        startTime: _startTime,
        duration: _duration,
        sequenceId: _sequenceId,
        isApproved: widget.act?.isApproved ?? false,
        participantIds: widget.act?.participantIds ?? [],
        assets: widget.act?.assets ?? [],
        createdBy: widget.act?.createdBy ?? 'u1',
      );

      final provider = Provider.of<ActsProvider>(context, listen: false);
      if (widget.act != null) {
        await provider.updateAct(act);
      } else {
        await provider.addAct(act);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.act != null ? 'Edit Act' : 'New Act'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            ListTile(
              title: Text('Start Time: ${DateFormat('MMM dd, yyyy – HH:mm').format(_startTime)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _startTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025,12,31),
                );
                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _startTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
            ),
            TextFormField(
              initialValue: _duration.inMinutes.toString(),
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter duration' : null,
              onSaved: (value) => _duration = Duration(minutes: int.parse(value!)),
            ),
            TextFormField(
              initialValue: _sequenceId.toString(),
              decoration: InputDecoration(labelText: 'Sequence ID'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter sequence ID' : null,
              onSaved: (value) => _sequenceId = int.parse(value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text('Save Act'),
            ),
          ],
        ),
      ),
    );
  }
}
