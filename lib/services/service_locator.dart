import 'api_service.dart';
import 'mock_api_service.dart';
import 'dummy_data_service.dart';

/// A simple service locator to provide either the real or mock API service
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  bool _useMock = false;
  late ApiService _apiService;

  /// Initialize the service locator
  Future<void> initialize({bool useMock = false}) async {
    _useMock = useMock;

    if (_useMock) {
      final mockService = MockApiService();

      // Seed the mock service with dummy data
      final events = DummyDataService.getEvents();
      final acts = DummyDataService.getActs();
      final contacts = DummyDataService.getContacts();

      mockService.seedMockData(events, acts, contacts);
      _apiService = mockService;
    } else {
      _apiService = ApiService();
    }
  }

  /// Get the API service (either real or mock)
  ApiService get apiService => _apiService;

  /// Check if using mock service
  bool get isMockService => _useMock;
}
