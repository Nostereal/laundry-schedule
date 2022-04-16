import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';

class MyBookingsList extends StatelessWidget {
  const MyBookingsList(
      {Key? key, required this.ownedBookings, this.padding, this.margin})
      : super(key: key);

  final List<TimeBooking> ownedBookings;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Мои записи", style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 12),
          for (final book in ownedBookings) MyBooking(booking: book),
        ],
      ),
    );
  }
}

class MyBooking extends StatelessWidget {
  const MyBooking({Key? key, required this.booking}) : super(key: key);

  final TimeBooking booking;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM');
    final timeFormat = DateFormat('H:mm');
    final start = booking.timeBracket.start;
    final end = booking.timeBracket.end;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        // decoration: BoxDecoration(
        //   color: Colors.grey[300],
        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateFormat.format(start), style: textTheme.headline5),
                const SizedBox(height: 4),
                Text(
                  "${timeFormat.format(start)} — ${timeFormat.format(end)}",
                  style: textTheme.headline6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
