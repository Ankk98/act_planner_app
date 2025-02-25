import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import 'contact_list_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({required this.eventId, super.key});

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<EventsProvider>(context).getEvent(eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Column(
        children: [
          // ...existing event details...
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Contacts'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContactListScreen(eventId: eventId),
              ),
            ),
          ),
          // ...existing code...
        ],
      ),
    );
  }
}
