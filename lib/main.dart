import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/event.dart'; // Import your models
import 'models/act.dart';
import 'models/contact.dart';
import 'models/asset.dart';
import 'services/dummy_data_service.dart';
import 'services/service_locator.dart';
import 'providers/events_provider.dart';
import 'providers/assets_provider.dart';
import 'providers/contacts_provider.dart';
import 'adapters/duration_adapter.dart';
import 'providers/acts_provider.dart';
import 'providers/filter_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/landing_screen.dart';

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

  // Initialize ServiceLocator
  await ServiceLocator().initialize(useMock: false);

  // Create providers
  final authProvider = AuthProvider();
  final eventsProvider = EventsProvider();
  final contactsProvider = ContactsProvider();
  final actsProvider = ActsProvider();
  final assetsProvider = AssetsProvider();
  final filterProvider = FilterProvider();

  // Load initial data
  await eventsProvider.loadEvents();
  await contactsProvider.loadContacts();
  await actsProvider.loadActs();
  await assetsProvider.loadAssets();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: eventsProvider),
        ChangeNotifierProvider.value(value: contactsProvider),
        ChangeNotifierProvider.value(value: actsProvider),
        ChangeNotifierProvider.value(value: assetsProvider),
        ChangeNotifierProvider.value(value: filterProvider),
      ],
      child: const MyApp(),
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
        useMaterial3: true,
        fontFamily: 'Roboto', // Use system font
        textTheme: Typography.material2021().black,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: const LandingScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Act Planner')),
      body: Center(child: Text('Welcome to the Act Planner App!')),
    );
  }
}
