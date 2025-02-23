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
import 'adapters/duration_adapter.dart';

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

  // Open Hive boxes
  await Hive.openBox<Event>('events');
  await Hive.openBox<Act>('acts');
  await Hive.openBox<Contact>('contacts');
  await Hive.openBox<Asset>('assets');

  // Seed dummy data
  await DummyDataService.seedData();

  runApp(
    ChangeNotifierProvider(
      create: (_) => EventsProvider()..loadEvents(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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