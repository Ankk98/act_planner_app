import 'package:hive/hive.dart';

part 'contact.g.dart'; // Generated file

@HiveType(typeId: 2)
class Contact {
  @HiveField(0) String id;
  @HiveField(1) String eventId;
  @HiveField(2) String userId;
  @HiveField(3) Role role;
  @HiveField(4) String? additionalInfo;
  @HiveField(5) String name;
  @HiveField(6) String phone;
  @HiveField(7) String email;

  Contact({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.role,
    this.additionalInfo,
    required this.name,
    required this.phone,
    required this.email,
  });
}

@HiveType(typeId: 9)
enum Role {
  @HiveField(0)
  Admin,
  @HiveField(1)
  Participant,
  @HiveField(2)
  Anchor,
  @HiveField(3)
  Audience,
}