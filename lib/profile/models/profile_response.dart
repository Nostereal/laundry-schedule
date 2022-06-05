import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/profile/models/profile_booking.dart';

class ProfileResponse {
  final ProfileInfo profileInfo;
  final List<ProfileBooking> bookings;

  ProfileResponse(
    this.profileInfo,
    this.bookings,
  );

  ProfileResponse.fromJson(Json json)
      : profileInfo = ProfileInfo.fromJson(json['profileInfo']),
        bookings =
            json['bookings'].map<ProfileBooking>((v) => ProfileBooking.fromJson(v)).toList();

  ProfileResponse copyWith({
    ProfileInfo? profileInfo,
    List<ProfileBooking>? bookings,
  }) =>
      ProfileResponse(
        profileInfo ?? this.profileInfo,
        bookings ?? this.bookings,
      );

  Json toJson() => {
        'profileInfo': profileInfo.toJson(),
        'bookings': bookings.map((v) => v.toJson()).toList(),
      };
}

class ProfileInfo {
  ProfileInfo(this.avatar, this.fullName, this.dorm, this.livingRoom);

  final String? avatar;
  final String fullName;
  final String dorm;
  final String livingRoom;

  ProfileInfo.fromJson(Json json)
      : avatar = json['avatar'],
        fullName = json['fullName'],
        dorm = json['dorm'],
        livingRoom = json['livingRoom'];

  ProfileInfo copyWith({
    String? avatar,
    String? fullName,
    String? dorm,
    String? livingRoom,
  }) =>
      ProfileInfo(
        avatar ?? this.avatar,
        fullName ?? this.fullName,
        dorm ?? this.dorm,
        livingRoom ?? this.livingRoom,
      );

  Json toJson() => {
        'avatar': avatar,
        'fullName': fullName,
        'dorm': dorm,
        'livingRoom': livingRoom,
      };
}
