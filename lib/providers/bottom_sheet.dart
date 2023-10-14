import 'package:flutter/material.dart';

class BottomSheetProvider with ChangeNotifier {
  bool _isBottomSheetVisible = false;
  IconData _buttonIcon = Icons.add;
  DateTime _selctedTime = DateTime.now();
  bool get isBottomSheetVisible => _isBottomSheetVisible;
  IconData get buttonIcon => _buttonIcon;
  DateTime get selectedTime => _selctedTime;

  void toggleBottomSheet() {
    _isBottomSheetVisible = !_isBottomSheetVisible;
    _buttonIcon = _isBottomSheetVisible ? Icons.check : Icons.add;
    notifyListeners();
  }

  void hideBottomSheet() {
    _isBottomSheetVisible = false;
    _buttonIcon = Icons.add;
    notifyListeners();
  }

  void setTime(date) {
    _selctedTime = date;
    notifyListeners();
  }
}
