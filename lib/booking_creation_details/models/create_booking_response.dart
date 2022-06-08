import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:washing_schedule/core/models/result.dart';

/// id : "524b843e-e8a4-4202-b3dc-87ed108854ad"
/// timeBracket : {"start":"2022-06-09T13:00:00+03:00","end":"2022-06-09T13:50:00+03:00"}

@immutable
class CreateBookingResponse {
  const CreateBookingResponse({
    required this.id,
    required this.timeBracket,
  });

  CreateBookingResponse.fromJson(Json json)
      : id = json['id'],
        timeBracket = TimeBracket.fromJson(json['timeBracket']);

  final String id;
  final TimeBracket timeBracket;

  CreateBookingResponse copyWith({
    String? id,
    TimeBracket? timeBracket,
  }) =>
      CreateBookingResponse(
        id: id ?? this.id,
        timeBracket: timeBracket ?? this.timeBracket,
      );

  Json toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['timeBracket'] = timeBracket.toJson();
    return map;
  }
}

/// start : "2022-06-09T13:00:00+03:00"
/// end : "2022-06-09T13:50:00+03:00"

@immutable
class TimeBracket {
  const TimeBracket({
    required this.start,
    required this.end,
  });

  TimeBracket.fromJson(Json json)
      : start = DateTime.parse(json['start']).toLocal(),
        end = DateTime.parse(json['end']).toLocal();

  final DateTime start;
  final DateTime end;

  TimeBracket copyWith({
    DateTime? start,
    DateTime? end,
  }) =>
      TimeBracket(
        start: start ?? this.start,
        end: end ?? this.end,
      );

  Json toJson() {
    final map = <String, dynamic>{};
    map['start'] = start.toIso8601String();
    map['end'] = end.toIso8601String();
    return map;
  }
}
