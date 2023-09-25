import 'package:flutter/material.dart';

class CalendarProvider with ChangeNotifier {
  DateTime _focusedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }
}
