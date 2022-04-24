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

  static ColorScheme darkColorScheme = ColorScheme.dark(
    secondary: const Color(0xff008c88),
    secondaryVariant: const Color(0xff006e69),
    onSurface: Colors.grey[300]!,
    onBackground: Colors.grey[300]!,
  );

  static ThemeData get darkTheme {
    final textColor = Colors.grey[300]!;
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
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 36, fontWeight: FontWeight.bold, color: textColor),
        headline2: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
        headline3: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
        headline4: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        headline5: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
        headline6: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: textColor),
        subtitle1: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
        subtitle2: TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color: textColor),
        bodyText1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
        bodyText2: TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
        caption: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w300, color: textColor),
        button: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: darkColorScheme.secondaryVariant,
        shape: cardShape,
      ),
      dividerColor: darkColorScheme.secondary,
      iconTheme: IconThemeData(color: textColor),
      bottomSheetTheme: const BottomSheetThemeData(shape: bottomSheetShape),
      // cardColor: primaryDark,
    );
  }
}
