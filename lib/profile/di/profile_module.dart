import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/profile/profile_api.dart';
import 'package:washing_schedule/profile/profile_repository.dart';

bindProfileDependencies() {
  getIt.registerLazySingleton<ProfileApi>(() => ProfileApi());
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
}