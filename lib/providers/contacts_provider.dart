import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart';

class ContactsProvider with ChangeNotifier {
  final ApiService _apiService = ServiceLocator().apiService;
  List<Contact> _contacts = [];
  String? _currentEventId;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentEventId => _currentEventId;

  List<Contact> get contacts {
    if (_currentEventId == null) {
      return [];
    }
    return _contacts.where((contact) => contact.eventId == _currentEventId).toList();
  }

  Contact getContact(String id) {
    return _contacts.firstWhere(
      (contact) => contact.id == id,
      orElse: () => throw Exception('Contact not found'),
    );
  }

  Future<void> loadContacts() async {
    if (_currentEventId == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, fetch from API
        final apiContacts = await _apiService.getContacts(_currentEventId!);
        _contacts = apiContacts;
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Contact>('contacts');
        _contacts = box.values.where((contact) => contact.eventId == _currentEventId).toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load contacts: $e';
      notifyListeners();
    }
  }

  Future<void> addContact(Contact contact) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final createdContact = await _apiService.createContact(contact);
        if (createdContact != null) {
          await loadContacts();
        } else {
          _errorMessage = 'Failed to create contact';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Contact>('contacts');
        await box.put(contact.id, contact);
        await loadContacts();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error adding contact: $e';
      notifyListeners();
    }
  }

  Future<void> updateContact(Contact contact) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final updatedContact = await _apiService.updateContact(contact);
        if (updatedContact != null) {
          await loadContacts();
        } else {
          _errorMessage = 'Failed to update contact';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Contact>('contacts');
        await box.put(contact.id, contact);
        await loadContacts();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error updating contact: $e';
      notifyListeners();
    }
  }

  Future<void> deleteContact(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_apiService.isAuthenticated) {
        // For online mode, use API
        final success = await _apiService.deleteContact(id);
        if (success) {
          await loadContacts();
        } else {
          _errorMessage = 'Failed to delete contact';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        // For offline mode, use Hive
        final box = Hive.box<Contact>('contacts');
        await box.delete(id);
        await loadContacts();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error deleting contact: $e';
      notifyListeners();
    }
  }

  void setCurrentEvent(String? eventId) {
    _currentEventId = eventId;
    if (eventId != null) {
      loadContacts();
    } else {
      _contacts = [];
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
