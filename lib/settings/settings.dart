import 'package:build_context/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washing_schedule/design_system/theme_notifier.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static String routeName = '/profile/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {

    Widget themeOptionWidget(ThemeOption theme) {
      return Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Text(
          theme.name,
          style: context.textTheme.headline6,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.appLocal.settingsPageTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              context.appLocal.themeSelectorHeader,
              style: context.textTheme.headline4,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Consumer(
              builder: (context, ThemeNotifier themeNotifier, child) => CupertinoSlidingSegmentedControl(
                thumbColor: context.theme.colorScheme.primaryContainer,
                groupValue: themeNotifier.themeMode,
                // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                children: {
                  ThemeMode.system: themeOptionWidget(SystemTheme(context)),
                  ThemeMode.light: themeOptionWidget(LightTheme(context)),
                  ThemeMode.dark: themeOptionWidget(DarkTheme(context)),
                },
                onValueChanged: (ThemeMode? mode) {
                  if (mode != null) themeNotifier.themeMode = mode;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract class ThemeOption {
  abstract final String name;
  abstract final ThemeMode themeMode;
}

class SystemTheme extends ThemeOption {
  SystemTheme(BuildContext context) {
    name = context.appLocal.systemThemeName;
  }

  @override
  final ThemeMode themeMode = ThemeMode.system;

  @override
  late final String name;
}

class LightTheme extends ThemeOption {
  LightTheme(BuildContext context) {
    name = context.appLocal.lightThemeName;
  }

  @override
  final ThemeMode themeMode = ThemeMode.light;

  @override
  late final String name;
}

class DarkTheme extends ThemeOption {
  DarkTheme(BuildContext context) {
    name = context.appLocal.darkThemeName;
  }

  @override
  final ThemeMode themeMode = ThemeMode.dark;

  @override
  late final String name;
}
