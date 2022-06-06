import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/schedule/models/available_dates.dart';

class DaySelectorListView extends StatefulWidget {

  static double height = 64;
  static double selectedItemScale = 1.15;

  const DaySelectorListView({
    Key? key,
    required this.dates,
    required this.selectedItemAlignment,
    required this.itemScrollController,
    this.selectedIndex = 2,
    this.onTap,
  }) : super(key: key);

  final AvailableDates dates;
  final double selectedItemAlignment;
  final ItemScrollController itemScrollController;
  final Function(int)? onTap;
  final int selectedIndex;

  @override
  DaySelectorListViewState createState() => DaySelectorListViewState();
}

class DaySelectorListViewState extends State<DaySelectorListView> {
  // List<DateTime> _days = [];
  // final int daysBeforeToday = 2;

  @override
  void initState() {
    super.initState();
    // final DateTime now = DateTime.now();
    // const int daysInAdvance = 14;
    // final prevDays = List.generate(
    //   daysBeforeToday,
    //       (index) => now.subtract(Duration(days: daysBeforeToday - index)),
    // );
    // final futureDays = List.generate(
    //   daysInAdvance,
    //       (idx) => DateTime.now().add(Duration(days: idx)),
    // );
    // _days = prevDays + futureDays;
  }

  final borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    final dates = widget.dates.dates;
    return ScrollablePositionedList.builder(
        padding: EdgeInsets.symmetric(
          vertical: DaySelectorListView.height / 2 * (DaySelectorListView.selectedItemScale - 1),
        ),
        itemScrollController: widget.itemScrollController,
        initialScrollIndex: widget.selectedIndex,
        initialAlignment: widget.selectedItemAlignment,
        itemCount: dates.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final day = dates[index];
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