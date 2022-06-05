import 'dart:convert';

import 'package:washing_schedule/auth/models/auth_response.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/network/client/http_client.dart';
import 'package:washing_schedule/di/application_module.dart';

class AuthApi {
  final HttpClient client = getIt.get();

  Future<Result<AuthResponse>> authorize(String login, String password) async {
    Map body = {
      'login': login,
      'password': password,
    };
    final response = await client.post("1/auth", body: json.encode(body));
    final Result<AuthResponse> result = parseResult(
      response.body,
      (json) => AuthResponse.fromJson(json),
    );
    return result;
  }
}
