import 'dart:convert';

import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/network/client/http_client.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'models/profile_response.dart';

class ProfileApi {
  final HttpClient client = getIt.get();

  Future<Result<ProfileResponse>> getProfileInfo(String token) async {
    final response = await client.get("1/profile", queryParams: { 'token': [token] });
    return parseResult(
      response.body,
      (json) => ProfileResponse.fromJson(json),
    );
  }

  Future<Result<Object?>> deleteBooking(String bookingId) async {
    Map body = {
      'id': bookingId,
    };
    final response = await client.delete("1/booking", body: json.encode(body));
    return parseResult(
      response.body,
      (json) => null,
    );
  }
}
