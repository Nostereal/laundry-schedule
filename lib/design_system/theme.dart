import 'package:flutter/material.dart';

final primarySwatchLight = Colors.amber;

final lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      minimumSize: const Size.fromHeight(48),
    ),
  ),
  primarySwatch: primarySwatchLight,
  textTheme: const TextTheme(
    headline4: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    headline5: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    subtitle1: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    subtitle2: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    caption: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
    button: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  cardTheme: CardTheme(
    elevation: 1,
    shape: cardShape,
  ),
  cardColor: primarySwatchLight,
);

final cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
