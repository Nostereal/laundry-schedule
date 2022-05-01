import 'dart:io';

import 'package:flutter/cupertino.dart';

class L10n {
  static const all = [
    Locale("ru"),
    Locale("en"),
  ];

  static String get systemLocale => Platform.localeName.substring(0,2);
}
