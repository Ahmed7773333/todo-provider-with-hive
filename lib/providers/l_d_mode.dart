import 'package:flutter/material.dart';
import '../app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _mode = AppTheme.lightTheme;

  ThemeData get mode => _mode;

  void setTheme(ThemeData mod) {
    _mode = mod;
    notifyListeners();
  }
}
