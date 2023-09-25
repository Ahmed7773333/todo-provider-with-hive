import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}
