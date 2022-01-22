import 'package:washing_schedule/mocked_data/bookings.dart';

class BookingCreationDetailsArgs {
  final TimeBracket timeBracket;
  final User user;

  BookingCreationDetailsArgs(this.timeBracket, this.user);
}