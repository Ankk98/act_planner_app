import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/acts_provider.dart';
import 'act_form_screen.dart';
import 'package:act_planner_app/screens/timeline_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  final String eventName;

  const EventDetailScreen({Key? key, required this.eventId, required this.eventName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ActsProvider>(
      builder: (context, actsProvider, child) {
        actsProvider.setCurrentEvent(eventId);
        final acts = actsProvider.acts;

        return Scaffold(
          appBar: AppBar(
            title: Text(eventName),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Details for event: $eventName (ID: $eventId)'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimelineScreen(eventId: eventId),
                      ),
                    );
                  },
                  child: const Text('View Timeline'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
