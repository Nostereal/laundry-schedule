import 'package:washing_schedule/booking_creation_details/booking_api.dart';
import 'package:washing_schedule/booking_creation_details/models/booking_intention_info.dart';
import 'package:washing_schedule/booking_creation_details/models/create_booking_response.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/di/application_module.dart';

class BookingRepository {
  final BookingApi api = getIt.get();

  Future<Result<BookingIntentionInfo>> getIntentionInfo(
    String token,
    DateTime date,
    int sessionNum,
  ) {
    return api.getIntentionInfo(token, date, sessionNum);
  }

  Future<Result<CreateBookingResponse>> createBooking(
    String token,
    int sessionNum,
    DateTime date,
  ) {
    return api.createBooking(token, sessionNum, date);
  }
}
