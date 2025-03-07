import 'package:flutter_contacts/flutter_contacts.dart' as phone_contacts;
import 'package:permission_handler/permission_handler.dart';
import '../models/contact.dart';

class ContactImportService {
  static Future<List<Contact>> importContacts(String eventId) async {
    // Request contacts permission
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      throw Exception('Contacts permission denied');
    }

    // Get all contacts
    final contacts = await phone_contacts.FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );

    // Convert phone contacts to app contacts
    return contacts.map((phoneContact) {
      final phone =
          phoneContact.phones.isNotEmpty
              ? phoneContact.phones.first.number
              : '';
      final email =
          phoneContact.emails.isNotEmpty
              ? phoneContact.emails.first.address
              : '';

      return Contact(
        id: DateTime.now().toString(),
        eventId: eventId,
        userId: DateTime.now().toString(),
        name: phoneContact.displayName,
        phone: phone,
        email: email,
        role: Role.Participant,
      );
    }).toList();
  }
}
