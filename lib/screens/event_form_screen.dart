import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';

class EventFormScreen extends StatefulWidget {
  final Event? event;

  EventFormScreen({this.event});

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _venue;
  late DateTime _date;
  late TimeOfDay _time;
  late EventType _type;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _name = widget.event!.name;
      _description = widget.event!.description;
      _venue = widget.event!.venue;
      _date = widget.event!.date;
      _time = TimeOfDay.fromDateTime(widget.event!.startTime);
      _type = widget.event!.type;
    } else {
      _name = '';
      _description = '';
      _venue = '';
      _date = DateTime.now();
      _time = TimeOfDay.now();
      _type = EventType.Wedding;
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final startTime = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      final event = Event(
        id: widget.event?.id ?? DateTime.now().toString(),
        name: _name,
        description: _description,
        date: _date,
        venue: _venue,
        startTime: startTime,
        actIds: widget.event?.actIds ?? [],
        contactIds: widget.event?.contactIds ?? [],
        type: _type,
      );

      final provider = Provider.of<EventsProvider>(context, listen: false);
      if (widget.event != null) {
        await provider.updateEvent(event);
      } else {
        await provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'New Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Event Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            TextFormField(
              initialValue: _venue,
              decoration: InputDecoration(labelText: 'Venue'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a venue' : null,
              onSaved: (value) => _venue = value!,
            ),
            ListTile(
              title: Text('Date'),
              subtitle: Text('${_date.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) setState(() => _date = date);
              },
            ),
            ListTile(
              title: Text('Time'),
              subtitle: Text(_time.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (time != null) setState(() => _time = time);
              },
            ),
            DropdownButtonFormField<EventType>(
              value: _type,
              decoration: InputDecoration(labelText: 'Event Type'),
              items: EventType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              )).toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
