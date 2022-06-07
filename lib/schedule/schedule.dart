import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details_args.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/design_system/alert_banner.dart';
import 'package:washing_schedule/design_system/content_placeholder.dart';
import 'package:washing_schedule/design_system/theme.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/schedule/day_selector.dart';
import 'package:washing_schedule/schedule/models/available_dates.dart';
import 'package:washing_schedule/schedule/models/schedule_booking.dart';
import 'package:washing_schedule/schedule/models/schedule_for_date.dart';
import 'package:washing_schedule/schedule/models/session.dart';
import 'package:washing_schedule/schedule/models/session_type.dart';
import 'package:washing_schedule/schedule/schedule_repository.dart';

class SchedulePage extends StatelessWidget with AppBarProvider {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Expanded(child: CalendarPagerView()),
        ],
      ),
    );
  }

  @override
  AppBar? provideAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.schedulePageTitle),
    );
  }
}

class CalendarPagerView extends StatefulWidget {
  const CalendarPagerView({Key? key}) : super(key: key);

  @override
  CalendarPagerViewState createState() => CalendarPagerViewState();
}

class CalendarPagerViewState extends State<CalendarPagerView> {
  static const int _initialIndex = 0;
  int selectedIndex = _initialIndex;
  final ItemScrollController itemScrollController = ItemScrollController();
  final PageController pageViewController =
      PageController(initialPage: _initialIndex);
  final double selectedItemAlignment =
      0.393; // todo: calculate from display width and card size
  final Duration _duration = const Duration(milliseconds: 300);

  bool _isPageAnimating = false;

  late Future<Result<AvailableDates>> _futureAvailableDates;
  final ScheduleRepository repository = getIt.get();

  @override
  void initState() {
    super.initState();
    _futureAvailableDates = repository.getAvailableDates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureAvailableDates,
      builder: (BuildContext context,
          AsyncSnapshot<Result<AvailableDates>> snapshot) {
        if (snapshot.hasErrorOrFailureResult) {
          final typedError = snapshot.typedError;
          return ContentPlaceholder(
            title: typedError.message,
            action: TextButton(
              onPressed: () {
                setState(() {
                  _futureAvailableDates = repository.getAvailableDates();
                });
              },
              child: Text(AppLocalizations.of(context)!.refresh),
            ),
          );
        } else if (snapshot.hasSuccessResult) {
          final AvailableDates dates = snapshot.successData();
          // todo: pass dates into DaySelectorListView
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  height: DaySelectorListView.height *
                      DaySelectorListView.selectedItemScale,
                  child: DaySelectorListView(
                    dates: dates,
                    selectedItemAlignment: selectedItemAlignment,
                    itemScrollController: itemScrollController,
                    selectedIndex: selectedIndex,
                    onTap: (index) {
                      onPageChanged(index);
                      itemScrollController.scrollTo(
                        index: index,
                        duration: _duration,
                        alignment: selectedItemAlignment,
                      );

                      _isPageAnimating = true;
                      pageViewController
                          .animateToPage(
                            index,
                            duration: _duration * 2,
                            curve: Curves.easeInOut,
                          )
                          .then((_) => {_isPageAnimating = false});
                    },
                  ),
                ),
              ),
              Expanded(
                child: DaysPageView(
                  dates: dates.dates,
                  controller: pageViewController,
                  onPageChanged: (i) {
                    if (_isPageAnimating) return;

                    onPageChanged(i);
                    itemScrollController.scrollTo(
                      index: i,
                      duration: _duration,
                      alignment: selectedItemAlignment,
                    );
                  },
                ),
              )
            ],
          );
        }
        return const Center(
            child:
                CircularProgressIndicator()); // todo: skeletons like day selector view
      },
    );
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class DaysPageView extends StatelessWidget {
  const DaysPageView({
    Key? key,
    required this.dates,
    this.controller,
    this.onPageChanged,
  }) : super(key: key);

  final List<DateTime> dates;
  final PageController? controller;
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      allowImplicitScrolling: true,
      itemCount: dates.length,
      controller: controller,
      onPageChanged: onPageChanged,
      itemBuilder: (BuildContext context, int index) {
        final date = dates[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: DayList(key: ValueKey(date), date: date),
        );
      },
    );
  }
}

class DayList extends StatefulWidget {
  final DateTime date;

  const DayList({Key? key, required this.date}) : super(key: key);

  @override
  DayListState createState() => DayListState();
}

class DayListState extends State<DayList> {
  final ScheduleRepository _repository = getIt.get();

  late Future<Result<ScheduleForDate>> _futureScheduleForDate;

  @override
  void initState() {
    super.initState();
    _futureScheduleForDate = _repository.getScheduleForDate(widget.date);
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
              child: Text(AppLocalizations.of(context)!.refresh),
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
                    final sessionWidget = _getWidgetForSession(session);
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

  Widget _getWidgetForSession(Session session) {
    switch (session.type) {
      case SessionType.open:
        session as OpenSession;
        return _openSessionWidget(session);
      case SessionType.launch:
        session as LaunchSession;
        return _launchSessionWidget(session);
    }
  }

  Widget _openSessionWidget(OpenSession session) {
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

    if (session.bookings.length < session.maxBookingsPerSession) {
      bookingWidgets.add(
        FreeToBookCard(
          onTap: () {
            requireAuth(
              context,
            ).then((authResult) {
              if (authResult is Success) {
                Navigator.pushNamed(
                  context,
                  BookingCreationDetailsRoute.routeName,
                  arguments: BookingCreationDetailsArgs(
                    session.sessionNum,
                    me,
                  ), // todo: pass user info
                );
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
        title: AppLocalizations.of(context)!.createBookingButton,
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

void showTextSnackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
