import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool _isResponse = false;

  void setResponse(bool value) {
    _isResponse = value;
    notifyListeners();
  }
}


