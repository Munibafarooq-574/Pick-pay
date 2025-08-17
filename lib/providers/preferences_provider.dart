import 'package:flutter/material.dart';

class PreferencesProvider with ChangeNotifier {
  /// User ID (for current session)
  String _userId = '';

  /// App theme color (Hex string, e.g., '#2e4cb6')
  String _themeColor = '#2e4cb6';

  /// Example: dark mode preference
  bool _isDarkMode = false;

  // Getters
  String get userId => _userId;
  String get themeColor => _themeColor;
  bool get isDarkMode => _isDarkMode;

  // Setters with notifyListeners
  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  set themeColor(String value) {
    _themeColor = value;
    notifyListeners();
  }

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  /// Utility: Convert hex color string to Color object
  Color get themeColorAsColor {
    final buffer = StringBuffer();
    if (_themeColor.length == 6 || _themeColor.length == 7) buffer.write('ff');
    buffer.write(_themeColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Reset preferences (useful on logout)
  void resetPreferences() {
    _userId = '';
    _themeColor = '#2e4cb6';
    _isDarkMode = false;
    notifyListeners();
  }
}
