import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'event_form_screen.dart';
import 'contact_list_screen.dart';
import 'act_list_screen.dart'; // Import ActListScreen
import 'event_detail_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EventFormScreen())
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Consumer<EventsProvider>(
      builder: (context, eventsProvider, _) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search events',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: eventsProvider.setSearchQuery,
              ),
            ),
            SizedBox(width: 8),
            DropdownButton<EventType?>(
              value: null,
              hint: Text('Filter'),
              items: [
                DropdownMenuItem<EventType?>(
                  value: null,
                  child: Text('All'),
                ),
                ...EventType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                )),
              ],
              onChanged: eventsProvider.setFilterType,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Consumer<EventsProvider>(
      builder: (context, eventsProvider, _) => ListView.builder(
        itemCount: eventsProvider.events.length,
        itemBuilder: (context, index) {
          final event = eventsProvider.events[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(eventId: event.id, eventName: event.name),
                  ),
                );
              },
              child: ExpansionTile(
                title: Text(event.name),
                subtitle: Text(
                  '${DateFormat('MMM dd, yyyy').format(event.date)} at ${event.venue}',
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Manage Contacts'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactListScreen(eventId: event.id),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.music_note), // Add a music note icon
                    title: Text('Manage Acts'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActListScreen(eventId: event.id), // Navigate to ActListScreen
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Event Details'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(
                            eventId: event.id,
                            eventName: event.name,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
