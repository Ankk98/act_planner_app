import 'package:hive/hive.dart';
import '../models/event.dart';
import '../models/act.dart';
import '../models/contact.dart';
import '../models/asset.dart';

class DummyDataService {
  static final List<Contact> contacts = [
    Contact(
      id: 'c1',
      eventId: 'e1',
      userId: 'u1',
      role: Role.Admin,
      name: 'John Doe',
      phone: '+1234567890',
      email: 'john@example.com',
      additionalInfo: 'Event Coordinator',
    ),
    Contact(
      id: 'c2',
      eventId: 'e1',
      userId: 'u2',
      role: Role.Anchor,
      name: 'Jane Smith',
      phone: '+1987654320',
      email: 'jane@example.com',
      additionalInfo: 'Wedding MC',
    ),
    // ...more contacts
  ];

  static final List<Asset> assets = [
    Asset(
      id: 'a1',
      name: 'Background Music 1',
      relativePath: 'assets/audio/background1.mp3',
      type: AssetType.Audio,
      uploadedAt: DateTime.now(),
    ),
    Asset(
      id: 'a2',
      name: 'Event Poster',
      relativePath: 'assets/images/poster.jpg',
      type: AssetType.Image,
      uploadedAt: DateTime.now(),
    ),
    // ...more assets
  ];

  static final List<Event> events = [
    Event(
      id: 'e1',
      name: 'Kumar Wedding',
      description: 'Wedding ceremony and reception',
      date: DateTime(2024, 3, 15),
      venue: 'Royal Gardens',
      startTime: DateTime(2024, 3, 15, 18, 0),
      actIds: ['act1', 'act2', 'act3'],
      contactIds: ['c1', 'c2', 'c3', 'c4'],
      type: EventType.Wedding,
    ),
    Event(
      id: 'e2',
      name: 'St. Mary\'s Annual Day',
      description: 'School Annual Day Celebration',
      date: DateTime(2024, 4, 5),
      venue: 'School Auditorium',
      startTime: DateTime(2024, 4, 5, 16, 0),
      actIds: ['act4', 'act5', 'act6'],
      contactIds: ['c5', 'c6', 'c7', 'c8'],
      type: EventType.SchoolAnnualDay,
    ),
  ];

  static final List<Act> acts = [
    Act(
      id: 'act1',
      eventId: 'e1',
      name: 'Wedding Dance',
      description: 'Group dance performance',
      startTime: DateTime(2024, 3, 15, 19, 0),
      duration: Duration(minutes: 15),
      sequenceId: 1,
      isApproved: true,
      participantIds: ['c3', 'c4'],
      assets: [assets[0]],
      createdBy: 'u1',
    ),
    Act(
      id: 'act2',
      eventId: 'e1',
      name: 'Singing Performance',
      description: 'Solo singing performance',
      startTime: DateTime(2024, 3, 15, 19, 30),
      duration: Duration(minutes: 10),
      sequenceId: 2,
      isApproved: true,
      participantIds: ['c2'],
      assets: [],
      createdBy: 'u1',
    ),
    Act(
      id: 'act3',
      eventId: 'e1',
      name: 'Speech by Bride',
      description: 'A heartfelt speech by the bride',
      startTime: DateTime(2024, 3, 15, 20, 0),
      duration: Duration(minutes: 5),
      sequenceId: 3,
      isApproved: true,
      participantIds: ['c1'],
      assets: [],
      createdBy: 'u1',
    ),
    Act(
      id: 'act4',
      eventId: 'e2',
      name: 'Opening Act',
      description: 'Welcome dance performance',
      startTime: DateTime(2024, 4, 5, 16, 30),
      duration: Duration(minutes: 20),
      sequenceId: 1,
      isApproved: true,
      participantIds: ['c5', 'c6'],
      assets: [assets[1]],
      createdBy: 'u2',
    ),
    Act(
      id: 'act5',
      eventId: 'e2',
      name: 'Drama Performance',
      description: 'A short play by students',
      startTime: DateTime(2024, 4, 5, 17, 0),
      duration: Duration(minutes: 30),
      sequenceId: 2,
      isApproved: true,
      participantIds: ['c7', 'c8'],
      assets: [],
      createdBy: 'u2',
    ),
    Act(
      id: 'act6',
      eventId: 'e2',
      name: 'Award Ceremony',
      description: 'Awards distribution to students',
      startTime: DateTime(2024, 4, 5, 18, 0),
      duration: Duration(minutes: 15),
      sequenceId: 3,
      isApproved: true,
      participantIds: [],
      assets: [],
      createdBy: 'u2',
    ),
  ];

  static Future<void> seedData() async {
    final settings = await Hive.openBox('settings');
    final isFirstRun = settings.get('isFirstRun', defaultValue: true);

    if (isFirstRun) {
      final eventsBox = Hive.box<Event>('events');
      final actsBox = Hive.box<Act>('acts');
      final contactsBox = Hive.box<Contact>('contacts');
      final assetsBox = Hive.box<Asset>('assets');

      // Add sample assets to Hive
      await assetsBox.putAll({assets[0].id: assets[0], assets[1].id: assets[1]});

      await eventsBox.addAll(events);
      await actsBox.addAll(acts);
      await contactsBox.addAll(contacts);

      await settings.put('isFirstRun', false);
    }
  }
  
  // Methods to get dummy data for the mock API service
  static List<Event> getEvents() {
    return events;
  }
  
  static List<Act> getActs() {
    return acts;
  }
  
  static List<Contact> getContacts() {
    return contacts;
  }
}
