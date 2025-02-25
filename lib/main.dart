import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/event.dart'; // Import your models
import 'models/act.dart';
import 'models/contact.dart';
import 'models/asset.dart';
import 'services/dummy_data_service.dart';
import 'providers/events_provider.dart';
import 'screens/event_list_screen.dart';
import 'providers/contacts_provider.dart';
import 'adapters/duration_adapter.dart';
import 'providers/acts_provider.dart'; // Import ActsProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(ActAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(AssetAdapter());
  Hive.registerAdapter(EventTypeAdapter());
  Hive.registerAdapter(RoleAdapter());
  Hive.registerAdapter(AssetTypeAdapter());

  // Delete existing boxes to ensure clean state
  await Hive.deleteBoxFromDisk('events');
  await Hive.deleteBoxFromDisk('acts');
  await Hive.deleteBoxFromDisk('contacts');
  await Hive.deleteBoxFromDisk('assets');
  await Hive.deleteBoxFromDisk('settings');

  // Open Hive boxes
  await Hive.openBox<Event>('events');
  await Hive.openBox<Act>('acts');
  await Hive.openBox<Contact>('contacts');
  await Hive.openBox<Asset>('assets');

  // Seed dummy data
  await DummyDataService.seedData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EventsProvider()..loadEvents(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactsProvider()..loadContacts(),
        ),
        ChangeNotifierProvider( // Add ActsProvider
          create: (_) => ActsProvider()..loadActs(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Act Planner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Act Planner'),
      ),
      body: Center(
        child: Text('Welcome to the Act Planner App!'),
      ),
    );
  }
}