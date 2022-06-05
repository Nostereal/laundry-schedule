import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/profile/models/profile_response.dart';
import 'package:washing_schedule/profile/profile_api.dart';

class ProfileRepository {
  final ProfileApi api = getIt.get();

  Future<Result<ProfileResponse>> getProfileInfo(int userId) {
    return api.getProfileInfo(userId);
  }

  Future<Result<Object?>> deleteBooking(String bookingId) {
    return api.deleteBooking(bookingId);
  }
}