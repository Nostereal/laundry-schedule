import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:washing_schedule/booking_creation_details/models/booking_intention_info.dart';
import 'package:washing_schedule/booking_creation_details/models/create_booking_response.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/network/client/http_client.dart';
import 'package:washing_schedule/di/application_module.dart';

class BookingApi {
  final HttpClient client = getIt.get();

  Future<Result<BookingIntentionInfo>> getIntentionInfo(
    int userId,
    DateTime date,
    int sessionNum,
  ) async {
    Map<String, dynamic> query = {
      'userId': [userId.toString()],
      'date': [DateFormat('yyyy-MM-dd').format(date)],
      'sessionNum': [sessionNum.toString()],
    };
    final response = await client.get("1/booking/intentionInfo", queryParams: query);
    final Result<BookingIntentionInfo> result = parseResult(
      response.body,
      (json) => BookingIntentionInfo.fromJson(json),
    );
    return result;
  }

  Future<Result<CreateBookingResponse>> createBooking(
    int userId,
    int sessionNum,
    DateTime date,
  ) async {
    Json body = {
      'userId': userId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'sessionNum': sessionNum.toString(),
    };
    final response = await client.post("1/booking/create", body: json.encode(body));
    final Result<CreateBookingResponse> result = parseResult(
      response.body,
      (json) => CreateBookingResponse.fromJson(json),
    );
    return result;
  }
}
