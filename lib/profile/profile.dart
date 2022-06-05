import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/models/typed_error.dart';
import 'package:washing_schedule/design_system/list_item.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/app_bar_provider.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/profile/models/profile_booking.dart';
import 'package:washing_schedule/profile/models/profile_response.dart';
import 'package:washing_schedule/profile/profile_repository.dart';
import 'package:washing_schedule/schedule/schedule.dart';
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
  late Future<Result<ProfileResponse>> _futureProfileData;
  final ProfileRepository _profileRepository = getIt.get();
  ProfileResponse? _profileResponse;

  @override
  void initState() {
    super.initState();
    _futureProfileData = getUserId().then((userId) async {
      if (userId == null) {
        return await requireAuth(context).then(
          (authResult) {
            if (authResult is Success) {
              return _profileRepository.getProfileInfo(authResult.userId);
            } else {
              goHome(context);
              throw Exception("Auth didn't succeed");
            }
          },
        );
      } else {
        return _profileRepository.getProfileInfo(userId);
      }
    });

    // futureProfileData = Future.delayed(const Duration(milliseconds: 400))
    //     .then((_) => getUserId())
    //     .then((sessionId) async {
    //   if (sessionId == null) {
    //     return await requireAuth(context).then(
    //       (authResult) {
    //         if (authResult is Success) {
    //           return getProfileInfo(authResult.userId);
    //         } else {
    //           goHome(context);
    //           throw Exception("Auth didn't succeed");
    //         }
    //       },
    //     );
    //   } else {
    //     return getProfileInfo(sessionId);
    //   }
    // });
  }

  goHome(BuildContext context) {
    Phoenix.rebirth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: FutureBuilder(
        future: _futureProfileData,
        builder: (context, snapshot) {
          if (snapshot.hasErrorOrFailureResult) {
            final typedError = snapshot.typedError;
            // todo: create beautiful error screen
            return Text(typedError.message);
          } else if (snapshot.hasSuccessResult) {
            final textBodyStyle = Theme.of(context).textTheme.bodyText1;
            final ProfileResponse data = snapshot.successData();
            _profileResponse = data;
            final profileInfo = data.profileInfo;
            final bookings = data.bookings;
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
                          rightItem:
                              Text(profileInfo.fullName, style: textBodyStyle),
                        ),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.house_outlined),
                          rightItem: Text(
                            profileInfo.dorm,
                            style: textBodyStyle,
                          ),
                        ),
                        ListItem(
                          paddingHorizontal: horizontalPadding,
                          leftItem: const Icon(Icons.bed_outlined),
                          rightItem: Text(
                            profileInfo.livingRoom,
                            style: textBodyStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        MyBookingsList(
                          ownedBookings: bookings,
                          onBookingDeleted: _deleteBooking,
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
                                child: Text(
                                    AppLocalizations.of(context)!.logOutButton),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _deleteBooking(ProfileBooking bookingToDelete) async {
    final result = await _profileRepository.deleteBooking(bookingToDelete.id);
    if (result is FailureResult) {
      showTextSnackBar(context, result.error.message);
    } else {
      setState(() {
        _futureProfileData = Future.value(
          SuccessResult(
            _profileResponse!.copyWith(
              bookings: _profileResponse!.bookings
                  .where((b) => b.id != bookingToDelete.id)
                  .toList(),
            ),
          ),
        );
      });
    }
  }
}

extension on AsyncSnapshot {
  T successData<T>() => (data! as SuccessResult<T>).data;

  bool get hasSuccessResult => hasData && data is SuccessResult;

  bool get hasFailureData => hasData && data is FailureResult;

  bool get hasErrorOrFailureResult => hasError || hasFailureData;

  TypedError get typedError => hasFailureData
      ? (data as FailureResult).error
      : Unknown(defaultErrorMessage);
}
