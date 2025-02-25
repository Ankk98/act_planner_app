import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/contact.dart';

class ContactsProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  String _currentEventId = '';

  List<Contact> get contacts => _contacts.where(
    (contact) => contact.eventId == _currentEventId
  ).toList();

  void setCurrentEvent(String eventId) {
    _currentEventId = eventId;
    loadContacts();
  }

  Future<void> loadContacts() async {
    final box = Hive.box<Contact>('contacts');
    _contacts = box.values.toList();
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    final box = Hive.box<Contact>('contacts');
    await box.put(contact.id, contact);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    final box = Hive.box<Contact>('contacts');
    await box.put(contact.id, contact);
    await loadContacts();
  }

  Future<void> deleteContact(String id) async {
    final box = Hive.box<Contact>('contacts');
    await box.delete(id);
    await loadContacts();
  }
}
