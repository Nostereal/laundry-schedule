import 'package:flutter/material.dart';

class Themes {
  // static MaterialColor primaryDark = Colors.amber;
  static MaterialColor primaryLight = Colors.amber;

  static RoundedRectangleBorder cardShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

  static const RoundedRectangleBorder bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: primaryLight,
      appBarTheme: const AppBarTheme(elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        headline2: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        headline3: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        headline4: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        subtitle1: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        subtitle2: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        caption: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
        button: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: primaryLight,
        shape: cardShape,
      ),
      cardColor: primaryLight,
      bottomSheetTheme: const BottomSheetThemeData(shape: bottomSheetShape),
    );
  }

  static MaterialColor primaryDark = Colors.amber;

  static ColorScheme darkColorScheme =
      const ColorScheme.dark(secondaryVariant: Color(0xff009786));

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: darkColorScheme,
      // scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        headline2: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        headline3: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        headline4: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        headline5: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        headline6: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        subtitle1: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        subtitle2: TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white),
        bodyText1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        bodyText2: TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
        caption: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w300, color: Colors.white),
        button: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: darkColorScheme.secondaryVariant,
        shape: cardShape,
      ),
      dividerColor: darkColorScheme.secondary,
      bottomSheetTheme: const BottomSheetThemeData(shape: bottomSheetShape),
      // cardColor: primaryDark,
    );
  }
}
