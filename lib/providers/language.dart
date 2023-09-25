import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _appLocale = const Locale('en');
  Locale get appLocale => _appLocale;

  void changeLanguage(Locale newLocale) {
    _appLocale = newLocale;
    notifyListeners();
  }
}
