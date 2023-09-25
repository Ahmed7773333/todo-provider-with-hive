import 'package:flutter/material.dart';

class BottomSheetProvider with ChangeNotifier {
  bool _isBottomSheetVisible = false;
  IconData _buttonIcon = Icons.add;

  bool get isBottomSheetVisible => _isBottomSheetVisible;
  IconData get buttonIcon => _buttonIcon;

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
}
