import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    saveToPrefs(mode);
  }

  SharedPreferences? prefs;

  ThemeNotifier() {
    loadFromPrefs();
  }

  loadFromPrefs() async {
    await _initPrefs();
    themeMode = ThemeMode.values[prefs!.getInt(themeKey) ?? 0];
  }

  saveToPrefs(ThemeMode mode) async {
    await _initPrefs();
    prefs!.setInt(themeKey, mode.index);
  }

  _initPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  static String themeKey = "theme";
}