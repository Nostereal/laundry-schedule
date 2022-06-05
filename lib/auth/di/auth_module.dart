import 'package:washing_schedule/auth/auth_api.dart';
import 'package:washing_schedule/auth/auth_repository.dart';
import 'package:washing_schedule/di/application_module.dart';

bindAuthDependencies() {
  getIt.registerLazySingleton<AuthApi>(() => AuthApi());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
}