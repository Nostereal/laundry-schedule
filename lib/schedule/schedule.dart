import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details_args.dart';
import 'package:washing_schedule/design_system/theme.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';
import 'package:washing_schedule/utils/lists.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchedulePage extends StatelessWidget implements AppBarProvider {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
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
  _CalendarPagerViewState createState() => _CalendarPagerViewState();
}

class _CalendarPagerViewState extends State<CalendarPagerView> {
  static const int _initialIndex = 2;
  int selectedIndex = _initialIndex;
  final ItemScrollController itemScrollController = ItemScrollController();
  final PageController pageViewController =
      PageController(initialPage: _initialIndex);
  final double selectedItemAlignment =
      0.393; // todo: calculate from display width and card size
  final Duration _duration = const Duration(milliseconds: 300);

  bool _isPageAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SizedBox(
            height: DaySelectorListView.height * DaySelectorListView.selectedItemScale,
            child: DaySelectorListView(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: DaysPageView(
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
          ),
        )
      ],
    );
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class DaySelectorListView extends StatefulWidget {

  static double height = 64;
  static double selectedItemScale = 1.15;

  const DaySelectorListView({
    Key? key,
    required this.selectedItemAlignment,
    required this.itemScrollController,
    this.selectedIndex = 2,
    this.onTap,
  }) : super(key: key);

  final double selectedItemAlignment;
  final ItemScrollController itemScrollController;
  final Function(int)? onTap;
  final int selectedIndex;

  @override
  _DaySelectorListViewState createState() => _DaySelectorListViewState();
}

class _DaySelectorListViewState extends State<DaySelectorListView> {
  List<DateTime> _days = [];
  final int daysBeforeToday = 2;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    const int daysInAdvance = 14;
    final prevDays = List.generate(
      daysBeforeToday,
      (index) => now.subtract(Duration(days: daysBeforeToday - index)),
    );
    final futureDays = List.generate(
      daysInAdvance,
      (idx) => DateTime.now().add(Duration(days: idx)),
    );
    _days = prevDays + futureDays;
  }

  final borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
        padding: EdgeInsets.symmetric(
          vertical: DaySelectorListView.height / 2 * (DaySelectorListView.selectedItemScale - 1),
        ),
        itemScrollController: widget.itemScrollController,
        initialScrollIndex: widget.selectedIndex,
        initialAlignment: widget.selectedItemAlignment,
        itemCount: _days.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final day = _days[index];
          final String weekday = DateFormat("dd", L10n.systemLocale).format(day);
          final String month = DateFormat("MMM", L10n.systemLocale).format(day);
          final isItemSelected = widget.selectedIndex == index;
          final themeColor = Theme.of(context).colorScheme;
          return AnimatedScale(
            scale: isItemSelected ? DaySelectorListView.selectedItemScale : 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () {
                  widget.onTap?.call(index);
                },
                borderRadius: borderRadius,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: isItemSelected
                          ? themeColor.secondary
                          : themeColor.secondaryVariant),
                  child: SizedBox.square(
                    dimension: 64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          weekday,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: isItemSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          month,
                          style: TextStyle(
                            fontWeight: isItemSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class DaysPageView extends StatelessWidget {
  const DaysPageView({Key? key, this.controller, this.onPageChanged})
      : super(key: key);

  final PageController? controller;
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemBuilder: (BuildContext context, int index) {
        return const DayList();
      },
    );
  }
}

class DayList extends StatefulWidget {
  const DayList({Key? key}) : super(key: key);

  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  List<Widget> preWidgets = /*[const Divider(height: 1)]*/ [];
  List<Widget> widgets = [];
  List<Widget> postWidgets = /*[const Divider(height: 1)]*/ [];
  static const int _maxBookings = 3;

  @override
  void initState() {
    super.initState();
    widgets = windowed(bookings, _maxBookings).map((books) {
      // todo: pass timeBracket separately from bookings for empty bracket case
      List<Widget> bookings = books
          // ignore: unnecessary_cast
          .map((e) => Booking(
                booking: e,
                onTap: (b) {
                  showTextSnackBar(context,
                      "Should open details about booking by ${b.owner}");
                },
              ) as Widget)
          .toList();

      if (bookings.length < _maxBookings) {
        bookings.add(
          FreeToBookCard(
            onTap: () {
              requireAuth(
                context,
              ).then((authResult) {
                if (authResult is Success) {
                  Navigator.pushNamed(
                    context,
                    BookingCreationDetailsRoute.routeName,
                    arguments:
                        BookingCreationDetailsArgs(books.first.timeBracket, me),
                  );
                } else {
                  showTextSnackBar(context, 'Authorization failed 😔');
                }
              });
            },
          ),
        );
      }
      return TimeBracketBookings(children: bookings);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) =>
          const TimeLineDivider(time: "11:25"),
      itemCount: preWidgets.length + widgets.length + postWidgets.length,
      itemBuilder: (BuildContext context, int index) {
        // [0, 1] [2, 3, 4] [5]
        // if (index < preWidgets.length) return preWidgets[index];
        //
        // final beforePostSize = preWidgets.length + widgets.length;
        // if (index >= beforePostSize) {
        //   return postWidgets[index - beforePostSize];
        // }

        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TimeLineDivider(time: "11:25"),
              widgets[index],
            ],
          );
        }
        if (index == widgets.length - 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgets[index],
              const TimeLineDivider(time: "11:25"),
            ],
          );
        }

        return widgets[index];
      },
    );
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
  const Booking({Key? key, required this.booking, this.onTap = _defaultOnTap})
      : super(key: key);

  final TimeBooking booking;
  final Function(TimeBooking) onTap;

  static _defaultOnTap(TimeBooking b) {}

  @override
  Widget build(BuildContext context) {
    return ScheduleCard(
      title: booking.owner.toString(),
      onTap: () {
        onTap(booking);
      },
    );
  }
}

class FreeToBookCard extends StatelessWidget {
  const FreeToBookCard(
      {Key? key, this.onTap = _defaultOnTap})
      : super(key: key);

  final Function() onTap;

  static _defaultOnTap() {}

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
    this.onTap = _defaultOnTap,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final Function() onTap;

  static _defaultOnTap() {}

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
