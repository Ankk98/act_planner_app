import 'package:hive/hive.dart';

part 'event.g.dart'; // Generated file

@HiveType(typeId: 1)
class Event {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String description;
  @HiveField(3) DateTime date;
  @HiveField(4) String venue;
  @HiveField(5) DateTime startTime;
  @HiveField(6) List<String> actIds;
  @HiveField(7) List<String> contactIds;
  @HiveField(8) EventType type;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.venue,
    required this.startTime,
    required this.actIds,
    required this.contactIds,
    required this.type,
  });
}

@HiveType(typeId: 8)
enum EventType {
  @HiveField(0)
  Wedding,
  @HiveField(1)
  SchoolAnnualDay,
  @HiveField(2)
  Society,
}