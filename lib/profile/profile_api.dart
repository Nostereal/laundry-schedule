import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/network/client/http_client.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'models/profile_response.dart';

class ProfileApi {
  final HttpClient client = getIt.get();

  Future<Result<ProfileResponse>> getProfileInfo(int userId) async {
    final response = await client.get("1/profile", queryParams: { 'userId': [userId.toString()] });
    return parseResult(
      response.body,
      (json) => ProfileResponse.fromJson(json),
    );
  }

  Future<Result<Object?>> deleteBooking(String bookingId) async {
    final response = await client.delete("1/booking");
    return parseResult(
      response.body,
      (json) => null,
    );
  }
}
