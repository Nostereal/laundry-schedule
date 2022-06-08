import 'package:washing_schedule/booking_creation_details/booking_api.dart';
import 'package:washing_schedule/booking_creation_details/booking_repository.dart';
import 'package:washing_schedule/di/application_module.dart';

bindBookingCreationDependencies() {
  getIt.registerLazySingleton<BookingApi>(() => BookingApi());
  getIt.registerLazySingleton<BookingRepository>(() => BookingRepository());
}