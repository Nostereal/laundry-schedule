import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:washing_schedule/design_system/theme.dart';
import 'package:washing_schedule/design_system/theme_notifier.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/routing/routing.dart';
import 'package:washing_schedule/schedule/schedule.dart';
import 'package:washing_schedule/utils/routing.dart';
import 'app_bar_provider.dart';
import 'home_page_args.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


const double horizontalPadding = 20;

void main() {
  runApp(
    Phoenix(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier themeNotifier, child) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.schedulePageTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            themeMode: themeNotifier.themeMode,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            initialRoute: HomePage.routeName,
            onGenerateRoute: generateRoute,
            // onGenerateInitialRoutes: (String initialRouteName) {
            //   return [
            //     MaterialPageRoute(
            //       builder: (context) => const HomePage(),
            //       settings: RouteSettings(
            //         name: HomePage.routeName,
            //         arguments: HomePageArgs('Laundry schedule', 0),
            //       ),
            //     ),
            //   ];
            // },
            routes: routes,
          );
        },
      ),
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

    const List<AppBarProvider> pages = [
      SchedulePage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: pages[_bottomBarIndex].provideAppBar(context),
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
            label: AppLocalizations.of(context)!.bottomSheetScheduleLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: AppLocalizations.of(context)!.bottomSheetProfileLabel,
          ),
        ],
      ),
    );
  }
}
