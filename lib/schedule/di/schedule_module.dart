import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/schedule/schedule_api.dart';
import 'package:washing_schedule/schedule/schedule_repository.dart';

bindScheduleDependencies() {
  getIt.registerLazySingleton<ScheduleApi>(() => ScheduleApi());
  getIt.registerLazySingleton<ScheduleRepository>(() => ScheduleRepository());
}