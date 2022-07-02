import 'package:flutter/material.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details_args.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/design_system/alert_banner.dart';
import 'package:washing_schedule/design_system/content_placeholder.dart';
import 'package:washing_schedule/design_system/theme.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/schedule/models/schedule_booking.dart';
import 'package:washing_schedule/schedule/models/schedule_for_date.dart';
import 'package:washing_schedule/schedule/models/session.dart';
import 'package:washing_schedule/schedule/models/session_type.dart';
import 'package:washing_schedule/schedule/schedule_repository.dart';
import 'package:washing_schedule/utils/snackbars.dart';

class DayList extends StatefulWidget {
  final DateTime date;

  const DayList({Key? key, required this.date}) : super(key: key);

  @override
  DayListState createState() => DayListState();
}

class DayListState extends State<DayList> {
  final ScheduleRepository _repository = getIt.get();

  late Future<Result<ScheduleForDate>> _futureScheduleForDate;

  _initScheduleForDateFuture() {
    _futureScheduleForDate = _repository.getScheduleForDate(widget.date);
  }

  @override
  void initState() {
    super.initState();
    _initScheduleForDateFuture();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureScheduleForDate,
      builder: (
          BuildContext context,
          AsyncSnapshot<Result<ScheduleForDate>> snapshot,
          ) {
        if (snapshot.hasErrorOrFailureResult) {
          return ContentPlaceholder(
            title: snapshot.typedError.message,
            action: TextButton(
              onPressed: () {
                setState(() {
                  _futureScheduleForDate =
                      _repository.getScheduleForDate(widget.date);
                });
              },
              child: Text(context.appLocal.refresh),
            ),
          );
        } else if (snapshot.hasSuccessResult) {
          final ScheduleForDate scheduleForDate = snapshot.successData();
          final alert = scheduleForDate.alert;
          final sessions = scheduleForDate.sessions;
          return Column(
            children: [
              if (alert != null)
                AlertBanner(
                  title: alert.title,
                  body: alert.body,
                  margin: EdgeInsets.zero,
                ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return TimeLineDivider(time: sessions[index + 1].startTime);
                  },
                  itemCount: sessions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final session = sessions[index];
                    final sessionWidget = _getWidgetForSession(
                        session, scheduleForDate.canBookSinceSessionNum);
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TimeLineDivider(time: session.startTime),
                          sessionWidget,
                        ],
                      );
                    }

                    return sessionWidget;
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _getWidgetForSession(Session session, int canBookSinceSessionNum) {
    switch (session.type) {
      case SessionType.open:
        session as OpenSession;
        return _openSessionWidget(session, canBookSinceSessionNum);
      case SessionType.launch:
        session as LaunchSession;
        return _launchSessionWidget(session);
    }
  }

  Widget _openSessionWidget(OpenSession session, int canBookSinceSessionNum) {
    final List<Widget> bookingWidgets = session.bookings.map<Widget>((e) {
      return Booking(
        booking: e,
        onTap: (b) {
          showTextSnackBar(
            context,
            "Should open details about booking by ${b.owner}",
          );
        },
      );
    }).toList();

    if (session.bookings.length < session.maxBookingsPerSession &&
        session.sessionNum >= canBookSinceSessionNum) {
      bookingWidgets.add(
        FreeToBookCard(
          onTap: () {
            requireAuth(
              context,
            ).then((authResult) async {
              if (authResult is Success) {
                final bool? shouldRefresh = await Navigator.pushNamed<bool?>(
                  context,
                  BookingCreationDetailsRoute.routeName,
                  arguments: BookingCreationDetailsArgs(
                    sessionNum: session.sessionNum,
                    token: authResult.token,
                    date: widget.date,
                  ),
                );
                if (shouldRefresh ?? false) {
                  setState(_initScheduleForDateFuture);
                }
              } else {
                showTextSnackBar(context, 'Authorization failed 😔');
              }
            });
          },
        ),
      );
    }

    return TimeBracketBookings(children: bookingWidgets);
  }

  Widget _launchSessionWidget(LaunchSession session) {
    final banner = session.banner;
    return banner != null
        ? AlertBanner(
      title: banner.title,
      body: banner.body,
      margin: const EdgeInsets.symmetric(vertical: 8),
    )
        : const SizedBox.shrink();
  }
}

class TimeBracketBookings extends StatelessWidget {
  const TimeBracketBookings({Key? key, required this.children})
      : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: children,
      ),
    );
  }
}

class Booking extends StatelessWidget {
  const Booking({Key? key, required this.booking, this.onTap})
      : super(key: key);

  final ScheduleBooking booking;
  final Function(ScheduleBooking)? onTap;

  @override
  Widget build(BuildContext context) {
    return ScheduleCard(
      key: ValueKey(booking.id),
      title: booking.owner.toString(),
      onTap: () => onTap?.call(booking),
    );
  }
}

class FreeToBookCard extends StatelessWidget {
  const FreeToBookCard({Key? key, this.onTap}) : super(key: key);

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        cardTheme: theme.cardTheme.copyWith(
          color: Theme.of(context).canvasColor,
          shape: Themes.cardShape.copyWith(
            side: BorderSide(color: theme.cardTheme.color!, width: 1.5),
          ),
        ),
      ),
      child: ScheduleCard(
        title: context.appLocal.createBookingButton,
        icon: Icons.add,
        onTap: onTap,
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeLineDivider extends StatelessWidget {
  const TimeLineDivider({Key? key, required this.time, this.color})
      : super(key: key);

  final String time;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).dividerColor;
    return Row(
      children: [
        Text(
          time,
          style: TextStyle(fontSize: 12, color: color),
        ),
        Expanded(child: Divider(height: 1, indent: 6, color: color)),
      ],
    );
  }
}
