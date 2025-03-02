import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  String _filterName = 'ALL';
  String get filterName => _filterName;

  void setFilter(String newFilter) {
    if (_filterName != newFilter) {
      _filterName = newFilter;
      notifyListeners(); // Notify listeners to update the UI
    }
  }
} 