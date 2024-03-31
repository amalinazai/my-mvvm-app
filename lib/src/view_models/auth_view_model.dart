
import 'package:flutter/foundation.dart';
import 'package:my_mvvm_app/src/apis/auth/login_api.dart';
import 'package:my_mvvm_app/src/apis/auth/profile_api.dart';
import 'package:my_mvvm_app/src/models/result.dart';
import 'package:my_mvvm_app/src/models/user.dart';
import 'package:my_mvvm_app/src/services/database_service.dart';
import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/services/secure_storage_service.dart';
import 'package:my_mvvm_app/src/settings/app_prefs_service.dart';
import 'package:my_mvvm_app/src/utils/token_store_utils.dart';
import 'package:my_mvvm_app/src/utils/user_utils.dart';

enum AuthStatus { idle, loading, success, loginFailure, loggedOut }

class AuthViewModelState {

  AuthViewModelState({
    this.status = AuthStatus.idle,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });
  
  AuthStatus status;
  bool isAuthenticated;
  User? user;
  String? error;
}

class AuthViewModel with ChangeNotifier {
  AuthViewModelState _state = AuthViewModelState();
  AuthViewModelState get state => _state;

  Future<void> onTapLogIn(String username, String password) async {
    _state = AuthViewModelState(status: AuthStatus.loading);
    notifyListeners();

    // Replace with your authentication logic
    final result = await LoginAPI.fetch(username: username, password: password);
    
    switch (result) {
      case Success(value: (final User user, final String token)):

        /// store token
        await TokenStoreUtils.set(token);

        /// store user object
        await UserUtils.set(user);

        _state = AuthViewModelState(
          status: AuthStatus.success,
          isAuthenticated: true,
          user: user,
        );

      case Failure(message: final String error):
        _state = AuthViewModelState(
          status: AuthStatus.loginFailure,
          error: error,
        );
    }

    notifyListeners();
  }

  Future<void> onTapLogOut() async {
    _state = AuthViewModelState(status: AuthStatus.loading);
    notifyListeners();

    await locator<DatabaseService>().deleteAllData();
    await locator<SecureStorageService>().deleteAll();
    await locator<AppPrefsService>().clearAll();
    
    _state = AuthViewModelState(status: AuthStatus.loggedOut, isAuthenticated: false);
    notifyListeners();
  }

  Future<void> onUserInitialized() async {
    _state = AuthViewModelState(
      user: await UserUtils.get(),
    );
    notifyListeners();

    // fetch user data from API on initialize
    await onUserFetched();
  }

  Future<void> onUserFetched() async {
    _state = AuthViewModelState(status: AuthStatus.loading);
    notifyListeners();

    final profileFetch = await ProfileAPI.get();

    switch (profileFetch) {
      case Success(value: final User user):
        _state = AuthViewModelState(
          status: AuthStatus.success,
          isAuthenticated: true,
          user: user,
        );

        // save user data into isar to cache
        await UserUtils.set(user);

      case Failure(message: final String error):
        _state = AuthViewModelState(
          status: AuthStatus.loginFailure,
          error: error,
        );
    }

    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setAuthenticated(bool isAuthenticate) {
    _state = AuthViewModelState(isAuthenticated: isAuthenticate);
  }
}
