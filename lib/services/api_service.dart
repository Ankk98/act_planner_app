import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/act.dart';
import '../models/contact.dart';

class ApiService {
  static const String baseUrl = 'https://hostmyai.in/api/v1';
  String? _token;
  String? _userId;

  // Getter for checking if user is authenticated
  bool get isAuthenticated => _token != null;

  // Getter for user ID
  String? get userId => _userId;

  // Headers for authenticated requests
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Authentication methods
  Future<bool> register(String name, String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');
      debugPrint('Sending registration request to: ${url.toString()}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      debugPrint('Registration response status: ${response.statusCode}');
      debugPrint('Registration response body: ${response.body}');

      if (response.statusCode == 201) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      debugPrint('Sending login request to: ${url.toString()}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('Login response status: ${response.statusCode}');
      debugPrint('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['userId'];
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    if (_token == null) return;

    try {
      await http.post(Uri.parse('$baseUrl/auth/logout'), headers: _headers);
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _token = null;
      _userId = null;
    }
  }

  // Event methods
  Future<List<Event>> getEvents({
    String? search,
    EventType? type,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (type != null) 'type': type.toString().split('.').last,
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      };

      final uri = Uri.parse(
        '$baseUrl/events',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> eventList = data['events'];
        return eventList.map((json) => _parseEvent(json)).toList();
      } else {
        _handleError(response);
        return [];
      }
    } catch (e) {
      debugPrint('Get events error: $e');
      return [];
    }
  }

  Future<Event?> getEvent(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _parseEvent(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Get event error: $e');
      return null;
    }
  }

  Future<Event?> createEvent(Event event) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: _headers,
        body: jsonEncode({
          'name': event.name,
          'description': event.description,
          'date': event.date.toUtc().toIso8601String(),
          'venue': event.venue,
          'startTime': event.startTime.toUtc().toIso8601String(),
          'type': event.type.toString().split('.').last,
        }),
      );

      if (response.statusCode == 201) {
        return _parseEvent(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Create event error: $e');
      return null;
    }
  }

  Future<Event?> updateEvent(Event event) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/events/${event.id}'),
        headers: _headers,
        body: jsonEncode({
          'name': event.name,
          'description': event.description,
          'date': event.date.toUtc().toIso8601String(),
          'venue': event.venue,
          'startTime': event.startTime.toUtc().toIso8601String(),
          'type': event.type.toString().split('.').last,
        }),
      );

      if (response.statusCode == 200) {
        return _parseEvent(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Update event error: $e');
      return null;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      debugPrint('Delete event error: $e');
      return false;
    }
  }

  // Act methods
  Future<List<Act>> getActs(
    String eventId, {
    String? search,
    bool? approved,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (approved != null) 'approved': approved.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/events/$eventId/acts',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> actList = data['acts'];
        return actList.map((json) => _parseAct(json)).toList();
      } else {
        _handleError(response);
        return [];
      }
    } catch (e) {
      debugPrint('Get acts error: $e');
      return [];
    }
  }

  Future<Act?> getAct(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/acts/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _parseAct(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Get act error: $e');
      return null;
    }
  }

  Future<Act?> createAct(Act act) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events/${act.eventId}/acts'),
        headers: _headers,
        body: jsonEncode({
          'name': act.name,
          'description': act.description,
          'startTime': act.startTime.toUtc().toIso8601String(),
          'duration': act.duration.inSeconds,
          'sequenceId': act.sequenceId,
          'isApproved': act.isApproved,
          'participantIds': act.participantIds,
        }),
      );

      if (response.statusCode == 201) {
        return _parseAct(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Create act error: $e');
      return null;
    }
  }

  Future<Act?> updateAct(Act act) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/acts/${act.id}'),
        headers: _headers,
        body: jsonEncode({
          'name': act.name,
          'description': act.description,
          'startTime': act.startTime.toUtc().toIso8601String(),
          'duration': act.duration.inSeconds,
          'sequenceId': act.sequenceId,
          'isApproved': act.isApproved,
          'participantIds': act.participantIds,
        }),
      );

      if (response.statusCode == 200) {
        return _parseAct(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Update act error: $e');
      return null;
    }
  }

  Future<bool> deleteAct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/acts/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      debugPrint('Delete act error: $e');
      return false;
    }
  }

  Future<bool> reorderActs(
    String eventId,
    List<Map<String, dynamic>> actOrders,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/events/$eventId/acts/reorder'),
        headers: _headers,
        body: jsonEncode({'actOrders': actOrders}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      debugPrint('Reorder acts error: $e');
      return false;
    }
  }

  // Contact methods
  Future<List<Contact>> getContacts(
    String eventId, {
    String? search,
    Role? role,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (role != null) 'role': role.toString().split('.').last,
      };

      final uri = Uri.parse(
        '$baseUrl/events/$eventId/contacts',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> contactList = data['contacts'];
        return contactList.map((json) => _parseContact(json)).toList();
      } else {
        _handleError(response);
        return [];
      }
    } catch (e) {
      debugPrint('Get contacts error: $e');
      return [];
    }
  }

  Future<Contact?> getContact(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contacts/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _parseContact(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Get contact error: $e');
      return null;
    }
  }

  Future<Contact?> createContact(Contact contact) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events/${contact.eventId}/contacts'),
        headers: _headers,
        body: jsonEncode({
          'userId': contact.userId,
          'role': contact.role.toString().split('.').last,
          'additionalInfo': contact.additionalInfo,
          'name': contact.name,
          'phone': contact.phone,
          'email': contact.email,
        }),
      );

      if (response.statusCode == 201) {
        return _parseContact(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Create contact error: $e');
      return null;
    }
  }

  Future<Contact?> updateContact(Contact contact) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/contacts/${contact.id}'),
        headers: _headers,
        body: jsonEncode({
          'role': contact.role.toString().split('.').last,
          'additionalInfo': contact.additionalInfo,
          'name': contact.name,
          'phone': contact.phone,
          'email': contact.email,
        }),
      );

      if (response.statusCode == 200) {
        return _parseContact(jsonDecode(response.body));
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      debugPrint('Update contact error: $e');
      return null;
    }
  }

  Future<bool> deleteContact(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/contacts/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      debugPrint('Delete contact error: $e');
      return false;
    }
  }

  // Helper methods for parsing responses
  Event _parseEvent(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      venue: json['venue'],
      startTime: DateTime.parse(json['startTime']),
      actIds: json['actIds'] != null ? List<String>.from(json['actIds']) : [],
      contactIds:
          json['contactIds'] != null
              ? List<String>.from(json['contactIds'])
              : [],
      type: _parseEventType(json['type']),
    );
  }

  Act _parseAct(Map<String, dynamic> json) {
    return Act(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      duration: Duration(seconds: json['duration']),
      sequenceId: json['sequenceId'],
      isApproved: json['isApproved'],
      participantIds:
          json['participantIds'] != null
              ? List<String>.from(json['participantIds'])
              : [],
      assets: [], // Assets are not included in this implementation
      createdBy: json['createdBy'] ?? '',
    );
  }

  Contact _parseContact(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      role: _parseRole(json['role']),
      additionalInfo: json['additionalInfo'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  EventType _parseEventType(String typeStr) {
    switch (typeStr) {
      case 'Wedding':
        return EventType.Wedding;
      case 'SchoolAnnualDay':
        return EventType.SchoolAnnualDay;
      case 'Society':
        return EventType.Society;
      default:
        return EventType.Wedding; // Default value
    }
  }

  Role _parseRole(String roleStr) {
    switch (roleStr) {
      case 'Admin':
        return Role.Admin;
      case 'Participant':
        return Role.Participant;
      case 'Anchor':
        return Role.Anchor;
      case 'Audience':
        return Role.Audience;
      default:
        return Role.Participant; // Default value
    }
  }

  void _handleError(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      debugPrint('API Error: ${errorData['message']}');
    } catch (e) {
      debugPrint(
        'API Error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  }
}
