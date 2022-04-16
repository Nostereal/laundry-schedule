import 'package:flutter/material.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/design_system/list_item.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';
import 'package:washing_schedule/settings/settings.dart';

import 'my_bookings.dart';

class ProfilePage extends StatefulWidget implements AppBarProvider {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  AppBar? provideAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
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
  // late Future<String?> futureUserId;
  late Future<ProfileResponse> futureProfileData;

  @override
  void initState() {
    super.initState();
    // todo: replace with profile info
    // futureUserId = Future.delayed(const Duration(milliseconds: 400))
    //     .then((_) => getUserId());

    futureProfileData = Future.delayed(const Duration(milliseconds: 400))
        .then((_) => getUserId())
        .then((sessionId) =>
            getProfileInfo(sessionId!) /*todo: handle nullable sessionId*/);
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
                          rightItem: Text(snapshot.data!.fullName,
                              style: textBodyStyle),
                        ),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.house_outlined),
                          rightItem: Text(
                            snapshot.data!.hostel,
                            style: textBodyStyle,
                          ),
                        ),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.bed_outlined),
                          rightItem: Text(
                            snapshot.data!.room,
                            style: textBodyStyle,
                          ),
                        ),
                        MyBookingsList(
                          margin: const EdgeInsets.only(
                              left: horizontalPadding,
                              right: horizontalPadding,
                              top: 16),
                          ownedBookings: snapshot.data!.bookings,
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       vertical: 16.0, horizontal: horizontalPadding),
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: const [
                //         Icon(Icons.schedule_outlined),
                //         SizedBox(width: 4),
                //         Text('Мои записи'),
                //       ],
                //     ),
                //   ),
                // )
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
