import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/design_system/list_item.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';
import 'package:washing_schedule/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'my_bookings.dart';

class ProfilePage extends StatefulWidget implements AppBarProvider {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  AppBar? provideAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.profilePageTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
        ),
      ],
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileResponse> futureProfileData;

  @override
  void initState() {
    super.initState();
    futureProfileData = Future.delayed(const Duration(milliseconds: 400))
        .then((_) => getUserId())
        .then((sessionId) async {
      if (sessionId == null) {
        return await requireAuth(context).then(
          (authResult) {
            if (authResult is Success) {
              return getProfileInfo(authResult.userId);
            } else {
              goHome(context);
              throw Exception("Auth didn't succeed");
            }
          },
        );
      } else {
        return getProfileInfo(sessionId);
      }
    });
  }

  goHome(BuildContext context) {
    Phoenix.rebirth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: FutureBuilder<ProfileResponse>(
        future: futureProfileData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final textBodyStyle = Theme.of(context).textTheme.bodyText1;
            var data = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(88),
                            ),
                            child: const Icon(Icons.catching_pokemon, size: 88),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.person_outlined),
                          rightItem: Text(data.fullName, style: textBodyStyle),
                        ),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.house_outlined),
                          rightItem: Text(
                            data.hostel,
                            style: textBodyStyle,
                          ),
                        ),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.bed_outlined),
                          rightItem: Text(
                            data.room,
                            style: textBodyStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        MyBookingsList(
                          ownedBookings: data.bookings,
                          onBookingDeleted: (booking) {
                            setState(() {
                              futureProfileData = Future.value(
                                ProfileResponse(
                                  fullName: data.fullName,
                                  hostel: data.hostel,
                                  room: data.room,
                                  bookings: data.bookings
                                      .where((e) => e != booking)
                                      .toList(),
                                ),
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: OutlinedButton(
                              onPressed: () {
                                storeUserId(null);
                                goHome(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Text(AppLocalizations.of(context)!.logOutButton),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('ERROOOOOOOR!!!!');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProfileResponse {
  final String fullName;
  final String hostel;
  final String room;
  final List<TimeBooking> bookings;

  const ProfileResponse({
    required this.fullName,
    required this.hostel,
    required this.room,
    required this.bookings,
  });
}

Future<ProfileResponse> getProfileInfo(String sessionId) async {
  return Future.value(
    ProfileResponse(
      fullName: 'Михалевич Тёмочка',
      hostel: 'Общежитие №4',
      room: 'Комната №127',
      bookings: generateBookings(count: 3),
    ),
  );
}
