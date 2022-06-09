import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class L10n {
  static const all = [
    Locale("ru"),
    Locale("en"),
  ];

  static String get systemLocale => Platform.localeName.substring(0,2);
}

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get appLocal => AppLocalizations.of(this)!;
}
