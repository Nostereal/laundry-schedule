
import 'package:get_it/get_it.dart';
import 'package:washing_schedule/auth/di/auth_module.dart';
import 'package:washing_schedule/booking_creation_details/di/booking_creation_module.dart';
import 'package:washing_schedule/core/network/client/http_client.dart';
import 'package:washing_schedule/profile/di/profile_module.dart';
import 'package:washing_schedule/schedule/di/schedule_module.dart';

GetIt getIt = GetIt.instance;

bindDependencies() {
  getIt.registerLazySingleton<HttpClient>(() => LocalClient());
  bindAuthDependencies();
  bindProfileDependencies();
  bindScheduleDependencies();
  bindBookingCreationDependencies();
}