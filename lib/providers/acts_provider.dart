import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/act.dart';

class ActsProvider with ChangeNotifier {
  List<Act> _acts = [];
  String _currentEventId = '';

  List<Act> get acts {
    return _acts
        .where((act) => act.eventId == _currentEventId)
        .toList()
      ..sort((a, b) => a.sequenceId.compareTo(b.sequenceId));
  }

  void setCurrentEvent(String eventId) {
    _currentEventId = eventId;
    loadActs(); // Ensure acts are loaded when the current event is set
  }

  Future<void> loadActs() async {
    final box = Hive.box<Act>('acts');
    _acts = box.values.toList();
    notifyListeners();
  }

  Future<void> addAct(Act act) async {
    final box = Hive.box<Act>('acts');
    await box.put(act.id, act);
    _acts.add(act); // Update the local list
    await loadActs();
  }

  Future<void> updateAct(Act act) async {
    final box = Hive.box<Act>('acts');
    await box.put(act.id, act);
    _acts[_acts.indexWhere((element) => element.id == act.id)] = act;
    await loadActs();
  }

  Future<void> deleteAct(String id) async {
    final box = Hive.box<Act>('acts');
    await box.delete(id);
    await loadActs();
  }

  Future<void> reorderAct(int oldIndex, int newIndex) async {
    final currentActs = acts;  // Get the filtered list for current event
    if (oldIndex < 0 || newIndex < 0 || oldIndex >= currentActs.length || 
        (newIndex > oldIndex && newIndex > currentActs.length)) {
      return;  // Invalid indices, do nothing
    }

    // Adjust the target index
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final movedAct = currentActs[oldIndex];
    final box = Hive.box<Act>('acts');

    // Remove the act from the old position and insert at new position
    currentActs.removeAt(oldIndex);
    currentActs.insert(newIndex, movedAct);

    // Update sequence IDs for all affected acts
    for (int i = 0; i < currentActs.length; i++) {
      final act = currentActs[i];
      if (act.sequenceId != i + 1) {
        final updatedAct = Act(
          id: act.id,
          eventId: act.eventId,
          name: act.name,
          description: act.description,
          startTime: act.startTime,
          duration: act.duration,
          sequenceId: i + 1,
          isApproved: act.isApproved,
          participantIds: act.participantIds,
          assets: act.assets,
          createdBy: act.createdBy,
        );
        await box.put(updatedAct.id, updatedAct);
      }
    }

    await loadActs();  // Reload the acts to reflect changes
  }
}
