import 'package:flutter/material.dart';
import 'package:washing_schedule/core/models/result.dart';

@immutable
class BookingIntentionInfo {
  const BookingIntentionInfo({
    required this.ownerName,
    required this.date,
    required this.timeInterval,
  });

  BookingIntentionInfo.fromJson(Json json)
      : ownerName = json['ownerName'],
        date = DateTime.parse(json['date']),
        timeInterval = json['timeInterval'];

  final String ownerName;
  final DateTime date;
  final String timeInterval;

  BookingIntentionInfo copyWith({
    String? ownerName,
    DateTime? date,
    String? timeInterval,
  }) =>
      BookingIntentionInfo(
        ownerName: ownerName ?? this.ownerName,
        date: date ?? this.date,
        timeInterval: timeInterval ?? this.timeInterval,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ownerName'] = ownerName;
    map['date'] = date;
    map['timeInterval'] = timeInterval;
    return map;
  }
}
