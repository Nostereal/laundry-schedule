import 'package:flutter/material.dart';
import 'package:washing_schedule/core/models/banner.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/schedule/models/session.dart';

@immutable
class ScheduleForDate {
  final AlertBannerModel? alert;
  final int canBookSinceSessionNum;
  final int sessionSeconds;
  final DateTime date;
  final List<Session> sessions;

  const ScheduleForDate({
    this.alert,
    required this.canBookSinceSessionNum,
    required this.sessionSeconds,
    required this.date,
    required this.sessions,
  });

  ScheduleForDate.fromJson(Json json)
      : alert = json['alert'] != null
            ? AlertBannerModel.fromJson(json['alert'])
            : null,
        canBookSinceSessionNum = json['canBookSinceSessionNum'],
        sessionSeconds = json['sessionSeconds'],
        date = DateTime.parse(json['date']).toLocal(),
        sessions =
            json['sessions'].map<Session>((v) => Session.fromJson(v)).toList();

  ScheduleForDate copyWith({
    AlertBannerModel? alert,
    int? canBookSinceSessionNum,
    int? sessionSeconds,
    DateTime? date,
    List<Session>? sessions,
  }) =>
      ScheduleForDate(
        alert: alert ?? this.alert,
        canBookSinceSessionNum:
            canBookSinceSessionNum ?? this.canBookSinceSessionNum,
        sessionSeconds: sessionSeconds ?? this.sessionSeconds,
        date: date ?? this.date,
        sessions: sessions ?? this.sessions,
      );

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['alert'] = alert;
//   map['sessionSeconds'] = sessionSeconds;
//   map['date'] = date;
//   map['sessions'] = sessions.map((v) => v.toJson()).toList();
//   return map;
// }
}
