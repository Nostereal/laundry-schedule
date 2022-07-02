import 'package:flutter/material.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/home/home_page_args.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/schedule/schedule.dart';
import 'package:washing_schedule/utils/cast.dart';
import 'package:washing_schedule/utils/routing.dart';


const double horizontalPadding = 20;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomBarIndex = 0;
  PageController bottomBarController = PageController();

  void onPageChanged(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
    bottomBarController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final HomePageArgs args = extractArgsFrom(context);

    setState(() {
      bottomBarController =
          PageController(initialPage: args.bottomNavIndex ?? 0);
    });

    const List<Widget> pages = [
      SchedulePage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: cast<AppBarProvider>(pages[_bottomBarIndex])?.provideAppBar(context),
      body: PageView(
        restorationId: 'homePageView',
        physics: const NeverScrollableScrollPhysics(),
        controller: bottomBarController,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomBarIndex,
        onTap: onPageChanged,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today_outlined),
            label: context.appLocal.bottomSheetScheduleLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: context.appLocal.bottomSheetProfileLabel,
          ),
        ],
      ),
    );
  }
}
