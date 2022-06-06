import 'package:washing_schedule/core/models/result.dart';

class ScheduleBooking {
  final String id;
  final String owner;

  ScheduleBooking.fromJson(Json json)
      : id = json['id'],
        owner = json['owner'];
}
