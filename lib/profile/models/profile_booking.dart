import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/mocked_data/bookings.dart';

class ProfileBooking {
  final String id;
  final TimeBracket timeBracket;

  ProfileBooking(this.id, this.timeBracket);

  ProfileBooking.fromJson(Json json)
      : id = json['id'],
        timeBracket = TimeBracket.fromJson(json['timeBracket']);


  Json toJson() => {
    'id': id,
    'timeBracket': timeBracket.toJson(),
  };
}
