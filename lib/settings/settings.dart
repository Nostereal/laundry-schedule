import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:build_context/build_context.dart';
import 'package:provider/provider.dart';
import 'package:washing_schedule/design_system/theme_notifier.dart';
import 'package:washing_schedule/home/home.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              "Choose theme",
              style: context.textTheme.headline4,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Consumer(
              builder: (context, ThemeNotifier themeNotifier, child) => CupertinoSlidingSegmentedControl(
                groupValue: themeNotifier.themeMode,
                // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                children: {
                  ThemeMode.system: themeOptionWidget(SystemTheme()),
                  ThemeMode.light: themeOptionWidget(LightTheme()),
                  ThemeMode.dark: themeOptionWidget(DarkTheme()),
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

final themeVariants = [SystemTheme(), LightTheme(), DarkTheme()];

abstract class ThemeOption {
  abstract final String name;
  abstract final ThemeMode themeMode;
}

class SystemTheme extends ThemeOption {
  @override
  final ThemeMode themeMode = ThemeMode.system;

  @override
  final String name = "System";
}

class LightTheme extends ThemeOption {
  @override
  final ThemeMode themeMode = ThemeMode.light;

  @override
  final String name = "Light";
}

class DarkTheme extends ThemeOption {
  @override
  final ThemeMode themeMode = ThemeMode.dark;

  @override
  final String name = "Dark";
}
