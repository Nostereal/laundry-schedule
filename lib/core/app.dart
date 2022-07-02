import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:washing_schedule/design_system/theme.dart';
import 'package:washing_schedule/design_system/theme_notifier.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/routing/routing.dart';

void main() {
  bindDependencies();
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
            onGenerateTitle: (context) => context.appLocal.schedulePageTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            supportedLocales: L10n.all,
            themeMode: themeNotifier.themeMode,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            initialRoute: HomePage.routeName,
            onGenerateRoute: generateRoute,
            routes: routes,
          );
        },
      ),
    );
  }
}