// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/foundation.dart';
import 'package:my_mvvm_app/src/utils/auth_utils.dart';

enum StartViewState { initial, loading, loaded }

class StartViewModel with ChangeNotifier {
  StartViewState _state = StartViewState.initial;
  bool _isAuthenticated = false;

  StartViewState get state => _state;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initialize() async {
    _state = StartViewState.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isAuthenticated = await getAuthState();
    
    _state = StartViewState.loaded;
    notifyListeners();
  }
}
