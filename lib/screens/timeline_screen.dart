import 'package:act_planner_app/providers/acts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelineScreen extends StatefulWidget {
  final String eventId;

  const TimelineScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    super.initState();
    // Load acts for the event when the screen is initialized
    Provider.of<ActsProvider>(context, listen: false)
        .setCurrentEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
      ),
      body: Consumer<ActsProvider>(
        builder: (context, actsProvider, child) {
          final acts = actsProvider.acts;
          return ReorderableListView.builder(
            itemCount: acts.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                actsProvider.reorderAct(oldIndex, newIndex);
              });
            },
            itemBuilder: (context, index) {
              final act = acts[index];
              return Card(
                key: ValueKey(act.id),
                elevation: 2,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${act.sequenceId}'),
                  ),
                  title: Text(act.name),
                  subtitle: Text('Start Time: ${act.startTime}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
