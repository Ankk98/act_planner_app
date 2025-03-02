import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart';

class EventsProvider with ChangeNotifier {
  final ApiService _apiService = ServiceLocator().apiService;
  List<Event> _events = [];
  String _searchQuery = '';
  EventType? _filterType;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Event> get events {
    var filteredEvents = [..._events];
    
    if (_searchQuery.isNotEmpty) {
      filteredEvents = filteredEvents
          .where((event) => event.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_filterType != null) {
      filteredEvents = filteredEvents
          .where((event) => event.type == _filterType)
          .toList();
    }

    return filteredEvents;
  }

  Event getEvent(String id) {
    return _events.firstWhere(
      (event) => event.id == id,
      orElse: () => throw Exception('Event not found'),
    );
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // For online mode, fetch from API
      if (_apiService.isAuthenticated) {
        final apiEvents = await _apiService.getEvents(
          search: _searchQuery.isNotEmpty ? _searchQuery : null,
          type: _filterType,
        );
        _events = apiEvents;
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Event>('events');
        _events = box.values.toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load events: $e';
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final createdEvent = await _apiService.createEvent(event);
        if (createdEvent != null) {
          await loadEvents();
        } else {
          _errorMessage = 'Failed to create event';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Event>('events');
        await box.put(event.id, event);
        await loadEvents();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error adding event: $e';
      notifyListeners();
    }
  }

  Future<void> updateEvent(Event event) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final updatedEvent = await _apiService.updateEvent(event);
        if (updatedEvent != null) {
          await loadEvents();
        } else {
          _errorMessage = 'Failed to update event';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Event>('events');
        await box.put(event.id, event);
        await loadEvents();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error updating event: $e';
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final success = await _apiService.deleteEvent(id);
        if (success) {
          await loadEvents();
        } else {
          _errorMessage = 'Failed to delete event';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Event>('events');
        await box.delete(id);
        await loadEvents();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error deleting event: $e';
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadEvents(); // Reload with new search query
  }

  void setFilterType(EventType? type) {
    _filterType = type;
    loadEvents(); // Reload with new filter
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
