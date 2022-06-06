import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/schedule/models/available_dates.dart';
import 'package:washing_schedule/schedule/models/schedule_for_date.dart';
import 'package:washing_schedule/schedule/schedule_api.dart';

class ScheduleRepository {

  final ScheduleApi api = getIt.get();

  Future<Result<AvailableDates>> getAvailableDates() {
    return api.getAvailableDates();
  }

  Future<Result<ScheduleForDate>> getScheduleForDate(DateTime date) {
    return api.getScheduleForDate(date);
  }

}