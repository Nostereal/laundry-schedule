import 'package:flutter/material.dart';
import 'package:washing_schedule/booking_creation_details/booking_creation_details.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/home/home_page_args.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/settings/settings.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  HomePage.routeName: (context) => const HomePage(),
  BookingCreationDetailsRoute.routeName: (context) =>
      const BookingCreationDetailsRoute(),
  SettingsPage.routeName: (context) => const SettingsPage(),
};

Route<dynamic>? generateRoute(RouteSettings settings) {
  return routeGenerator[settings.name!]?.call(settings);
  // todo: should i create 404 page?
}

final Map<String, Route<dynamic> Function(RouteSettings)> routeGenerator = {
  ProfilePage.routeName: (settings) {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
      settings: RouteSettings(
        name: settings.name,
        arguments: HomePageArgs('Profile', 1),
      ),
    );
  },
};
