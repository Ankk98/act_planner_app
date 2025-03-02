import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/act.dart';
import '../models/asset.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart';

class ActsProvider with ChangeNotifier {
  final ApiService _apiService = ServiceLocator().apiService;
  List<Act> _acts = [];
  String? _currentEventId;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentEventId => _currentEventId;

  List<Act> get acts {
    if (_currentEventId == null) {
      return [];
    }
    return _acts.where((act) => act.eventId == _currentEventId).toList()
      ..sort((a, b) => a.sequenceId.compareTo(b.sequenceId));
  }

  Act getAct(String id) {
    return _acts.firstWhere(
      (act) => act.id == id,
      orElse: () => throw Exception('Act not found'),
    );
  }

  Future<void> loadActs() async {
    if (_currentEventId == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, fetch from API
        final apiActs = await _apiService.getActs(_currentEventId!);
        _acts = apiActs;
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Act>('acts');
        _acts = box.values.where((act) => act.eventId == _currentEventId).toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load acts: $e';
      notifyListeners();
    }
  }

  Future<void> addAct(Act act) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final createdAct = await _apiService.createAct(act);
        if (createdAct != null) {
          await loadActs();
        } else {
          _errorMessage = 'Failed to create act';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Act>('acts');
        await box.put(act.id, act);
        await loadActs();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error adding act: $e';
      notifyListeners();
    }
  }

  Future<void> updateAct(Act act) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final updatedAct = await _apiService.updateAct(act);
        if (updatedAct != null) {
          await loadActs();
        } else {
          _errorMessage = 'Failed to update act';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Act>('acts');
        await box.put(act.id, act);
        await loadActs();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error updating act: $e';
      notifyListeners();
    }
  }

  Future<void> deleteAct(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final success = await _apiService.deleteAct(id);
        if (success) {
          await loadActs();
        } else {
          _errorMessage = 'Failed to delete act';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Act>('acts');
        await box.delete(id);
        await loadActs();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error deleting act: $e';
      notifyListeners();
    }
  }

  Future<void> reorderAct(int oldIndex, int newIndex) async {
    if (_currentEventId == null) return;
    
    final actsList = acts;
    if (oldIndex >= actsList.length || newIndex >= actsList.length) return;

    // Adjust for removing the item
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final Act act = actsList.removeAt(oldIndex);
    actsList.insert(newIndex, act);

    // Update sequence IDs
    for (int i = 0; i < actsList.length; i++) {
      actsList[i].sequenceId = i + 1;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final actOrders = actsList.map((a) => {
          'id': a.id,
          'sequenceId': a.sequenceId,
        }).toList();
        
        final success = await _apiService.reorderActs(_currentEventId!, actOrders);
        if (success) {
          await loadActs();
        } else {
          _errorMessage = 'Failed to reorder acts';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Act>('acts');
        for (final act in actsList) {
          await box.put(act.id, act);
        }
        await loadActs();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error reordering acts: $e';
      notifyListeners();
    }
  }

  List<Asset> getAssetsForAct(String actId) {
    final act = getAct(actId);
    return act.assets;
  }

  Future<void> addAssetToAct(String actId, Asset asset) async {
    final act = getAct(actId);
    act.assets.add(asset);
    await updateAct(act);
  }

  Future<void> removeAssetFromAct(String actId, Asset asset) async {
    final act = getAct(actId);
    act.assets.removeWhere((a) => a.id == asset.id);
    await updateAct(act);
  }

  void setCurrentEvent(String? eventId) {
    _currentEventId = eventId;
    if (eventId != null) {
      loadActs();
    } else {
      _acts = [];
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
