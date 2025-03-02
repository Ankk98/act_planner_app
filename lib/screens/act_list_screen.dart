import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/acts_provider.dart';
import 'act_form_screen.dart';
import 'act_details_screen.dart';

class ActListScreen extends StatefulWidget {
  final String eventId;

  const ActListScreen({required this.eventId, super.key});

  @override
  _ActListScreenState createState() => _ActListScreenState();
}

class _ActListScreenState extends State<ActListScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely update the provider after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActsProvider>(context, listen: false)
          .setCurrentEvent(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final actsProvider = Provider.of<ActsProvider>(context);
    final acts = actsProvider.acts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActFormScreen(eventId: widget.eventId),
                ),
              );
            },
          ),
        ],
      ),
      body: acts.isEmpty
          ? const Center(
              child: Text('No acts available. Add some!'),
            )
          : ListView.builder(
              itemCount: acts.length,
              itemBuilder: (context, index) {
                final act = acts[index];
                return ListTile(
                  title: Text(act.name),
                  subtitle: Text(act.description),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ActDetailsScreen(act: act),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ActFormScreen(eventId: widget.eventId, act: act),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text("Are you sure you want to delete this act?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Delete"),
                                    onPressed: () {
                                      actsProvider.deleteAct(act.id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
