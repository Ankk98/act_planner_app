import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ServiceLocator().apiService;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _apiService.isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userId => _apiService.userId;

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.register(name, email, password);
      _isLoading = false;
      if (!result) {
        _errorMessage = 'Registration failed. Please try again.';
      }
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred during registration: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      _isLoading = false;
      if (!result) {
        _errorMessage = 'Login failed. Please check your credentials.';
      }
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred during login: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 