import 'package:washing_schedule/booking_creation_details/booking_api.dart';
import 'package:washing_schedule/booking_creation_details/models/booking_intention_info.dart';
import 'package:washing_schedule/booking_creation_details/models/create_booking_response.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/di/application_module.dart';

class BookingRepository {
  final BookingApi api = getIt.get();

  Future<Result<BookingIntentionInfo>> getIntentionInfo(
    int userId,
    DateTime date,
    int sessionNum,
  ) {
    return api.getIntentionInfo(userId, date, sessionNum);
  }

  Future<Result<CreateBookingResponse>> createBooking(
    int userId,
    int sessionNum,
    DateTime date,
  ) {
    return api.createBooking(userId, sessionNum, date);
  }
}
