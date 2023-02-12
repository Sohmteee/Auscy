import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool _isResponse = false;
  bool get isResponse => _isResponse;

  set isResponse {
    _isResponse = !_isResponse;
    notifyListeners();
  }
}
