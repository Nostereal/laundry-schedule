import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details.dart';
import 'package:washing_schedule/design_system/theme.dart';
import 'package:washing_schedule/schedule/schedule.dart';
import 'package:washing_schedule/utils/routing.dart';

import 'home_page_args.dart';

const double horizontalPadding = 20;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MaterialApp(
      title: 'Laundry schedule',
      theme: theme,
      initialRoute: HomePage.routeName,
      onGenerateInitialRoutes: (String initialRouteName) {
        return [
          MaterialPageRoute(
            builder: (context) => const HomePage(),
            settings: RouteSettings(
              name: HomePage.routeName,
              arguments: HomePageArgs('Laundry schedule'),
            ),
          ),
        ];
      },
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        AuthPage.routeName: (context) => BottomSheet(builder: (context) => const AuthPage(), onClosing: () {},),
        BookingCreationDetailsRoute.routeName: (context) =>
            const BookingCreationDetailsRoute(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController bottomBarController = PageController();
  int _bottomBarIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
    bottomBarController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final HomePageArgs args = extractArgsFrom(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: PageView(
        restorationId: 'homePageView',
        physics: const NeverScrollableScrollPhysics(),
        controller: bottomBarController,
        children: const [
          SchedulePage(),
          Center(child: Text("Profile")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomBarIndex,
        onTap: onPageChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
