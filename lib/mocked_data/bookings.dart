import 'dart:math';
import 'package:washing_schedule/core/models/result.dart';

const bookingTimeLimit = Duration(minutes: 45);
late Random random = Random();

String randomRoom({int limit = 200}) => random.nextInt(limit).toString();

User generateUser(
        {String firstName = "Тяночка",
        String secondName = "Вайфовна",
        String? room}) =>
    User(firstName, secondName, room);

TimeBooking generateSingleBooking({required final int index}) {
  final now = DateTime.now();
  return TimeBooking(
      TimeBracket(now.add(bookingTimeLimit * (index - 1)),
          now.add(bookingTimeLimit * index)),
      generateUser(room: randomRoom()));
}

List<TimeBooking> generateBookings({int count = 5}) {
  return List.generate(count, (index) => generateSingleBooking(index: index));
}

final List<TimeBooking> bookings = generateBookings(count: 8);

class User {
  final String firstName;
  final String lastName;
  final String? room;

  User(this.firstName, this.lastName, this.room);

  @override
  String toString() => "$lastName $firstName${room == null ? "" : " at $room"}";
}

final me = User('Артём', 'Михалев', '127');

class TimeBooking {
  final TimeBracket timeBracket;
  final User owner;

  TimeBooking(this.timeBracket, this.owner);
}

class TimeBracket {
  final DateTime start;
  final DateTime end;

  TimeBracket(this.start, this.end);

  TimeBracket.fromJson(Json json)
      : start = DateTime.parse(json['start']).toLocal(),
        end = DateTime.parse(json['end']).toLocal();

  Json toJson() => {
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };
}
