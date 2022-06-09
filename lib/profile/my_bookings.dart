import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:washing_schedule/profile/models/profile_booking.dart';

class MyBookingsList extends StatelessWidget {
  const MyBookingsList({
    Key? key,
    required this.ownedBookings,
    this.onBookingDeleted,
  }) : super(key: key);

  final List<ProfileBooking> ownedBookings;
  final Function(ProfileBooking)? onBookingDeleted;

  @override
  Widget build(BuildContext context) {
    const insets = EdgeInsets.only(
      left: horizontalPadding,
      right: horizontalPadding,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: insets,
          child: Text(
            context.appLocal.ownedBookingsHeader,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedCrossFade(
          firstChild: const NoBookingsBanner(),
          secondChild: Container(
            margin: insets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final book in ownedBookings)
                  MyBooking(
                    booking: book,
                    onBookingDeleted: onBookingDeleted,
                  ),
              ],
            ),
          ),
          crossFadeState: ownedBookings.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

class MyBooking extends StatelessWidget {
  const MyBooking({Key? key, required this.booking, this.onBookingDeleted})
      : super(key: key);

  final ProfileBooking booking;
  final Function(ProfileBooking)? onBookingDeleted;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM', L10n.systemLocale);
    final timeFormat = DateFormat('H:mm', L10n.systemLocale);
    final start = booking.timeBracket.start;
    final end = booking.timeBracket.end;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            if (onBookingDeleted != null)
              IconButton(
                onPressed: () {
                  onBookingDeleted!(booking);
                },
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
      ),
    );
  }
}

class NoBookingsBanner extends StatelessWidget {
  const NoBookingsBanner({
    Key? key,
    this.margin,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: padding,
      margin: margin,
      child: Card(
        margin: EdgeInsets.zero,
        color: context.platformBrightness == Brightness.dark
            ? Colors.grey[700]
            : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 20,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.appLocal.noOwnedBookingsBannerTitle,
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Text(
                context.appLocal.noOwnedBookingsBannerText,
                style: context.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
