import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/acts_provider.dart';
import 'package:act_planner_app/screens/timeline_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  final String eventName;

  const EventDetailScreen({super.key, required this.eventId, required this.eventName});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActsProvider>(context, listen: false).setCurrentEvent(widget.eventId);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final actsProvider = Provider.of<ActsProvider>(context);
    final acts = actsProvider.acts;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details for event: ${widget.eventName} (ID: ${widget.eventId})'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimelineScreen(eventId: widget.eventId),
                  ),
                );
              },
              child: const Text('View Timeline'),
            ),
          ],
        ),
      ),
    );
  }
}
