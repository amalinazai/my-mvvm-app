import 'package:my_mvvm_app/src/models/result.dart';
import 'package:my_mvvm_app/src/models/user.dart';
import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/services/network_exceptions.dart';
import 'package:my_mvvm_app/src/services/network_service.dart';

class ProfileAPI {
  static Future<Result<User, String>> get() async {
    try {
      final response = await locator<NetworkService>().get(
        '/auth/me',
        isRequireAuth: true,
      ) as Map<String, dynamic>;

      final profileResponse = ProfileResponse.fromJson(response);

      return Success(profileResponse.user);
    } catch (e) {
      return Failure(
        getNetworkErrorMessage(
          e,
          badResponseMessage: (data) {
            return (data as Map<String, dynamic>?)?['message'] as String?;
          },
        ),
      );
    }
  }
}

class ProfileResponse {
  ProfileResponse({required this.user});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      user: User.fromJson(json),
    );
  }
  final User user;
}
