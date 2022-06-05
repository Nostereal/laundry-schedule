import 'package:washing_schedule/auth/models/auth_response.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/di/application_module.dart';

import 'auth_api.dart';

class AuthRepository {

  final AuthApi api = getIt.get();

  Future<Result<AuthResponse>> authorize(String login, String password) {
    return api.authorize(login, password);
  }

}
