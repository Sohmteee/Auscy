import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool isResponse = false;

  void setResponse(bool value) {
    isResponse = value;
    notifyListeners();
  }
}
