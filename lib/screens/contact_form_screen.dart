import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';

class ContactFormScreen extends StatefulWidget {
  final String eventId;
  final Contact? contact;

  const ContactFormScreen({
    required this.eventId,
    this.contact,
    super.key,
  });

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _email;
  late Role _role;

  @override
  void initState() {
    super.initState();
    _name = widget.contact?.name ?? '';
    _phone = widget.contact?.phone ?? '';
    _email = widget.contact?.email ?? '';
    _role = widget.contact?.role ?? Role.Participant;
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final contact = Contact(
        id: widget.contact?.id ?? DateTime.now().toString(),
        eventId: widget.eventId,
        userId: widget.contact?.userId ?? DateTime.now().toString(),
        name: _name,
        phone: _phone,
        email: _email,
        role: _role,
      );

      final provider = Provider.of<ContactsProvider>(context, listen: false);
      if (widget.contact != null) {
        await provider.updateContact(contact);
      } else {
        await provider.addContact(contact);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact != null ? 'Edit Contact' : 'New Contact'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _phone,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a phone number' : null,
              onSaved: (value) => _phone = value!,
            ),
            TextFormField(
              initialValue: _email,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter an email' : null,
              onSaved: (value) => _email = value!,
            ),
            DropdownButtonFormField<Role>(
              value: _role,
              decoration: InputDecoration(labelText: 'Role'),
              items: Role.values.map((role) => DropdownMenuItem(
                value: role,
                child: Text(role.toString().split('.').last),
              )).toList(),
              onChanged: (value) => setState(() => _role = value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
