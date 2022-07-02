import 'package:flutter/material.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/schedule/calendar_page_view.dart';

class SchedulePage extends StatelessWidget with AppBarProvider {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
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
      title: Text(context.appLocal.schedulePageTitle),
    );
  }
}
