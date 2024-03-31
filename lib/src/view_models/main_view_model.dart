import 'package:flutter/material.dart';

class MainViewModel with ChangeNotifier {
  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  void updateTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}
