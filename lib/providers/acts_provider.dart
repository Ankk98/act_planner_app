import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/act.dart';
import '../models/asset.dart';
// Add this import

class ActsProvider with ChangeNotifier {
  List<Act> _acts = [];
  String? _currentEventId;

  List<Act> get acts => _currentEventId != null 
    ? _acts.where((act) => act.eventId == _currentEventId).toList()
    : _acts;

  void setCurrentEvent(String? eventId) {
    _currentEventId = eventId;
    notifyListeners();
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

  List<Asset> getAssetsForAct(String actId) {
    final act = _acts.firstWhere((act) => act.id == actId);
    return act.assets;
  }

  Future<void> addAssetToAct(String actId, Asset asset) async {
    final act = _acts.firstWhere((act) => act.id == actId);
    if (act.assets.any((a) => a.id == asset.id)) {
      return; // Asset already exists in act
    }
    
    final updatedAct = Act(
      id: act.id,
      eventId: act.eventId,
      name: act.name,
      description: act.description,
      startTime: act.startTime,
      duration: act.duration,
      sequenceId: act.sequenceId,
      isApproved: act.isApproved,
      participantIds: act.participantIds,
      assets: [...act.assets, asset],
      createdBy: act.createdBy,
    );
    await updateAct(updatedAct);
    notifyListeners();
  }

  Future<void> removeAssetFromAct(String actId, Asset asset) async {
    final act = _acts.firstWhere((act) => act.id == actId);
    final updatedAct = Act(
      id: act.id,
      eventId: act.eventId,
      name: act.name,
      description: act.description,
      startTime: act.startTime,
      duration: act.duration,
      sequenceId: act.sequenceId,
      isApproved: act.isApproved,
      participantIds: act.participantIds,
      assets: act.assets.where((a) => a.id != asset.id).toList(),
      createdBy: act.createdBy,
    );
    await updateAct(updatedAct);
  }
}
