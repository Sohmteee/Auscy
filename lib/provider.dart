import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool _isResponse = false;
  bool getIsResponse() => _isResponse;

  void toggleResponse() {
    _isResponse = !_isResponse;
    notifyListeners();
  }
}
