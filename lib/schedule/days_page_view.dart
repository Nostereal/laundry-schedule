import 'package:flutter/material.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/schedule/day_list.dart';

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