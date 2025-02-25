import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/act.dart';
import '../providers/acts_provider.dart';
import 'act_form_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({required this.eventId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ActsProvider>(
      builder: (context, actsProvider, child) {
        actsProvider.setCurrentEvent(eventId);
        final acts = actsProvider.acts;

        return Scaffold(
          appBar: AppBar(
            title: Text('Event Details'),
          ),
          body: ReorderableListView.builder(
            itemCount: acts.length,
            onReorder: (oldIndex, newIndex) {
              Provider.of<ActsProvider>(context, listen: false)
                  .reorderAct(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final act = acts[index];
              return Card(
                key: ValueKey('act_${act.id}_$index'), // Unique key for each act
                child: ListTile(
                  title: Text(act.name),
                  subtitle: Text('Sequence: ${act.sequenceId}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActFormScreen(
                            eventId: eventId,
                            act: act,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActFormScreen(eventId: eventId),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
