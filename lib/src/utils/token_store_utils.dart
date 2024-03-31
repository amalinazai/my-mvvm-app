

import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/services/secure_storage_service.dart';

/// Helper class for user token CRUD functions.
class TokenStoreUtils {
  static const userTokenKey = 'user_token';

  static Future<String?> get() async {
    return locator<SecureStorageService>().read(userTokenKey);
  }

  static Future<void> set(String token) async {
    await locator<SecureStorageService>().write(userTokenKey, token);
  }

  static Future<void> delete() async {
    await locator<SecureStorageService>().delete(userTokenKey);
  }
}
