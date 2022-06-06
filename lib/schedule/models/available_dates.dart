import 'package:washing_schedule/core/models/result.dart';

class AvailableDates {
  final List<DateTime> _dates;

  AvailableDates(this._dates);

  AvailableDates.fromJson(Json json)
      : _dates = json['dates'] != null
            ? json['dates'].map<DateTime>((date) => DateTime.parse(date)).toList()
            : [];

  AvailableDates copyWith({
    List<DateTime>? dates,
  }) =>
      AvailableDates(
        dates ?? _dates,
      );

  List<DateTime> get dates => _dates;

  Json toJson() {
    final map = <String, dynamic>{};
    map['dates'] = _dates;
    return map;
  }
}
