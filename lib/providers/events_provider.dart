import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';

class EventsProvider with ChangeNotifier {
  List<Event> _events = [];
  String _searchQuery = '';
  EventType? _filterType;

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

  Future<void> loadEvents() async {
    final box = Hive.box<Event>('events');
    _events = box.values.toList();
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    final box = Hive.box<Event>('events');
    await box.put(event.id, event);
    await loadEvents();
  }

  Future<void> updateEvent(Event event) async {
    final box = Hive.box<Event>('events');
    await box.put(event.id, event);
    await loadEvents();
  }

  Future<void> deleteEvent(String id) async {
    final box = Hive.box<Event>('events');
    await box.delete(id);
    await loadEvents();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterType(EventType? type) {
    _filterType = type;
    notifyListeners();
  }
}
