import 'dart:async';
import 'dart:math';
import '../models/event.dart';
import '../models/act.dart';
import '../models/contact.dart';
import 'api_service.dart';

/// A mock implementation of ApiService for testing without a real backend
class MockApiService extends ApiService {
  String? _token;
  String? _userId;
  final Random _random = Random();

  // In-memory storage for mock data
  final Map<String, Event> _events = {};
  final Map<String, Act> _acts = {};
  final Map<String, Contact> _contacts = {};

  // Mock users for authentication
  final Map<String, Map<String, String>> _users = {
    'test@example.com': {
      'id': 'user1',
      'name': 'Test User',
      'password': 'password123',
    },
    'admin@example.com': {
      'id': 'user2',
      'name': 'Admin User',
      'password': 'admin123',
    },
  };

  @override
  bool get isAuthenticated => _token != null;

  @override
  String? get userId => _userId;

  // Simulate network delay
  Future<void> _delay() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
  }

  // Authentication methods
  @override
  Future<bool> register(String name, String email, String password) async {
    await _delay();

    // Check if email already exists
    if (_users.containsKey(email)) {
      return false;
    }

    // Create new user
    final userId = 'user${_users.length + 1}';
    _users[email] = {'id': userId, 'name': name, 'password': password};

    return true;
  }

  @override
  Future<bool> login(String email, String password) async {
    await _delay();

    // Check if user exists and password matches
    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _userId = _users[email]!['id'];
      return true;
    }

    return false;
  }

  @override
  Future<void> logout() async {
    await _delay();
    _token = null;
    _userId = null;
  }

  // Event methods
  @override
  Future<List<Event>> getEvents({
    String? search,
    EventType? type,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int limit = 20,
  }) async {
    await _delay();

    var filteredEvents = _events.values.toList();

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      filteredEvents =
          filteredEvents
              .where(
                (event) =>
                    event.name.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
    }

    // Apply type filter
    if (type != null) {
      filteredEvents =
          filteredEvents.where((event) => event.type == type).toList();
    }

    // Apply date filters
    if (fromDate != null) {
      filteredEvents =
          filteredEvents
              .where(
                (event) =>
                    event.date.isAfter(fromDate) ||
                    event.date.isAtSameMomentAs(fromDate),
              )
              .toList();
    }

    if (toDate != null) {
      filteredEvents =
          filteredEvents
              .where(
                (event) =>
                    event.date.isBefore(toDate) ||
                    event.date.isAtSameMomentAs(toDate),
              )
              .toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, filteredEvents.length);

    if (startIndex >= filteredEvents.length) {
      return [];
    }

    return filteredEvents.sublist(startIndex, endIndex);
  }

  @override
  Future<Event?> getEvent(String id) async {
    await _delay();
    return _events[id];
  }

  @override
  Future<Event?> createEvent(Event event) async {
    await _delay();
    _events[event.id] = event;
    return event;
  }

  @override
  Future<Event?> updateEvent(Event event) async {
    await _delay();
    if (!_events.containsKey(event.id)) {
      return null;
    }
    _events[event.id] = event;
    return event;
  }

  @override
  Future<bool> deleteEvent(String id) async {
    await _delay();
    if (!_events.containsKey(id)) {
      return false;
    }
    _events.remove(id);

    // Also remove associated acts and contacts
    _acts.removeWhere((_, act) => act.eventId == id);
    _contacts.removeWhere((_, contact) => contact.eventId == id);

    return true;
  }

  // Act methods
  @override
  Future<List<Act>> getActs(
    String eventId, {
    String? search,
    bool? approved,
    int page = 1,
    int limit = 20,
  }) async {
    await _delay();

    var filteredActs =
        _acts.values.where((act) => act.eventId == eventId).toList();

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      filteredActs =
          filteredActs
              .where(
                (act) => act.name.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
    }

    // Apply approval filter
    if (approved != null) {
      filteredActs =
          filteredActs.where((act) => act.isApproved == approved).toList();
    }

    // Sort by sequence ID
    filteredActs.sort((a, b) => a.sequenceId.compareTo(b.sequenceId));

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, filteredActs.length);

    if (startIndex >= filteredActs.length) {
      return [];
    }

    return filteredActs.sublist(startIndex, endIndex);
  }

  @override
  Future<Act?> getAct(String id) async {
    await _delay();
    return _acts[id];
  }

  @override
  Future<Act?> createAct(Act act) async {
    await _delay();
    if (!_events.containsKey(act.eventId)) {
      return null;
    }
    _acts[act.id] = act;
    return act;
  }

  @override
  Future<Act?> updateAct(Act act) async {
    await _delay();
    if (!_acts.containsKey(act.id)) {
      return null;
    }
    _acts[act.id] = act;
    return act;
  }

  @override
  Future<bool> deleteAct(String id) async {
    await _delay();
    if (!_acts.containsKey(id)) {
      return false;
    }
    _acts.remove(id);
    return true;
  }

  @override
  Future<bool> reorderActs(
    String eventId,
    List<Map<String, dynamic>> actOrders,
  ) async {
    await _delay();

    for (final order in actOrders) {
      final actId = order['id'] as String;
      final sequenceId = order['sequenceId'] as int;

      if (_acts.containsKey(actId)) {
        final act = _acts[actId]!;
        act.sequenceId = sequenceId;
        _acts[actId] = act;
      }
    }

    return true;
  }

  // Contact methods
  @override
  Future<List<Contact>> getContacts(
    String eventId, {
    String? search,
    Role? role,
    int page = 1,
    int limit = 20,
  }) async {
    await _delay();

    var filteredContacts =
        _contacts.values
            .where((contact) => contact.eventId == eventId)
            .toList();

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      filteredContacts =
          filteredContacts
              .where(
                (contact) =>
                    contact.name.toLowerCase().contains(search.toLowerCase()) ||
                    contact.email.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
    }

    // Apply role filter
    if (role != null) {
      filteredContacts =
          filteredContacts.where((contact) => contact.role == role).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, filteredContacts.length);

    if (startIndex >= filteredContacts.length) {
      return [];
    }

    return filteredContacts.sublist(startIndex, endIndex);
  }

  @override
  Future<Contact?> getContact(String id) async {
    await _delay();
    return _contacts[id];
  }

  @override
  Future<Contact?> createContact(Contact contact) async {
    await _delay();
    if (!_events.containsKey(contact.eventId)) {
      return null;
    }
    _contacts[contact.id] = contact;
    return contact;
  }

  @override
  Future<Contact?> updateContact(Contact contact) async {
    await _delay();
    if (!_contacts.containsKey(contact.id)) {
      return null;
    }
    _contacts[contact.id] = contact;
    return contact;
  }

  @override
  Future<bool> deleteContact(String id) async {
    await _delay();
    if (!_contacts.containsKey(id)) {
      return false;
    }
    _contacts.remove(id);
    return true;
  }

  // Helper method to seed mock data
  void seedMockData(
    List<Event> events,
    List<Act> acts,
    List<Contact> contacts,
  ) {
    for (final event in events) {
      _events[event.id] = event;
    }

    for (final act in acts) {
      _acts[act.id] = act;
    }

    for (final contact in contacts) {
      _contacts[contact.id] = contact;
    }
  }
}
