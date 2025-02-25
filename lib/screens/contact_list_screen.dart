import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';
import 'contact_form_screen.dart';

class ContactListScreen extends StatelessWidget {
  final String eventId;

  const ContactListScreen({required this.eventId, super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ContactsProvider>(context, listen: false).setCurrentEvent(eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContactFormScreen(eventId: eventId),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ContactsProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.contacts.length,
          itemBuilder: (context, index) {
            final contact = provider.contacts[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(contact.name[0]),
              ),
              title: Text(contact.name),
              subtitle: Text('${contact.role.toString().split('.').last} • ${contact.phone}'),
              trailing: PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ContactFormScreen(
                          eventId: eventId,
                          contact: contact,
                        ),
                      ),
                    );
                  } else if (value == 'delete') {
                    await provider.deleteContact(contact.id);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
