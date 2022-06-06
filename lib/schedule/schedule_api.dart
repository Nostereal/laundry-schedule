import 'package:intl/intl.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/network/client/http_client.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/schedule/models/available_dates.dart';
import 'package:washing_schedule/schedule/models/schedule_for_date.dart';

class ScheduleApi {
  final HttpClient client = getIt.get();

  Future<Result<AvailableDates>> getAvailableDates() async {
    final response = await client.get("1/bookings/dates");
    return parseResult(
      response.body,
      (json) => AvailableDates.fromJson(json),
    );
  }

  Future<Result<ScheduleForDate>> getScheduleForDate(DateTime date) async {
    final Map<String, dynamic> query = {
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
    final response = await client.get("1/bookings", queryParams: query);
    return parseResult(
      response.body,
      (json) => ScheduleForDate.fromJson(json),
    );
  }
}
