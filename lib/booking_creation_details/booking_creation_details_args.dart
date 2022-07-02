import 'package:flutter/material.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';

@immutable
class BookingCreationDetailsArgs {
  final int sessionNum;
  final String token;
  final DateTime date;

  const BookingCreationDetailsArgs({
    required this.sessionNum,
    required this.token,
    required this.date,
  });
}
