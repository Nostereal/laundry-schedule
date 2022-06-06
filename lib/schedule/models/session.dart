import 'package:flutter/material.dart';
import 'package:washing_schedule/core/models/banner.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/schedule/models/schedule_booking.dart';
import 'package:washing_schedule/schedule/models/session_type.dart';

@immutable
abstract class Session {
  abstract final SessionType type;
  abstract final String startTime;

  const Session();

  factory Session.fromJson(Json json) {
    final sessionType = sessionByType(json['type']);
    switch (sessionType) {
      case SessionType.open:
        return OpenSession.fromJson(sessionType, json);
      case SessionType.launch:
        return LaunchSession.fromJson(sessionType, json);
    }
  }
}

@immutable
class OpenSession extends Session {
  @override
  final SessionType type;

  @override
  final String startTime;
  final int sessionNum;
  final int maxBookingsPerSession;
  final List<ScheduleBooking> bookings;

  const OpenSession({
    required this.type,
    required this.startTime,
    required this.sessionNum,
    required this.bookings,
    required this.maxBookingsPerSession,
  });

  OpenSession.fromJson(this.type, Json json)
      : startTime = json['startTime'],
        sessionNum = json['sessionNum'],
        maxBookingsPerSession = json['maxBookingsPerSession'],
        bookings = json['bookings']
            ?.map<ScheduleBooking>(
              (v) => ScheduleBooking.fromJson(v),
            )
            .toList();
}

@immutable
class LaunchSession extends Session {
  @override
  final SessionType type;
  @override
  final String startTime;

  final AlertBanner? banner;

  LaunchSession.fromJson(this.type, Json json)
      : startTime = json['startTime'],
        banner = json['banner'] != null
            ? AlertBanner.fromJson(json['banner'])
            : null;
}

/// type : "open"
/// startTime : "08:00"
/// sessionNum : 1
/// bookings : []

// class Sessions {
//   Sessions({
//     String? type,
//     String? startTime,
//     int? sessionNum,
//     List<dynamic>? bookings,
//   }) {
//     _type = type;
//     _startTime = startTime;
//     _sessionNum = sessionNum;
//     _bookings = bookings;
//   }
//
//   Sessions.fromJson(dynamic json) {
//     _type = json['type'];
//     _startTime = json['startTime'];
//     _sessionNum = json['sessionNum'];
//     if (json['bookings'] != null) {
//       _bookings = [];
//       json['bookings'].forEach((v) {
//         _bookings?.add(Dynamic.fromJson(v));
//       });
//     }
//   }
//
//   String? _type;
//   String? _startTime;
//   int? _sessionNum;
//   List<dynamic>? _bookings;
//
//   Sessions copyWith({
//     String? type,
//     String? startTime,
//     int? sessionNum,
//     List<dynamic>? bookings,
//   }) =>
//       Sessions(
//         type: type ?? _type,
//         startTime: startTime ?? _startTime,
//         sessionNum: sessionNum ?? _sessionNum,
//         bookings: bookings ?? _bookings,
//       );
//
//   String? get type => _type;
//
//   String? get startTime => _startTime;
//
//   int? get sessionNum => _sessionNum;
//
//   List<dynamic>? get bookings => _bookings;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['type'] = _type;
//     map['startTime'] = _startTime;
//     map['sessionNum'] = _sessionNum;
//     if (_bookings != null) {
//       map['bookings'] = _bookings?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }
