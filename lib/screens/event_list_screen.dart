import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'event_form_screen.dart';

class EventListScreen extends StatelessWidget {
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
            child: ListTile(
              title: Text(event.name),
              subtitle: Text(
                '${DateFormat('MMM dd, yyyy').format(event.date)} at ${event.venue}',
              ),
              trailing: PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EventFormScreen(event: event),
                      ),
                    );
                  } else if (value == 'delete') {
                    await eventsProvider.deleteEvent(event.id);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
