import 'package:get_it/get_it.dart';
import 'package:my_baby/configs/database.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppDatabase());
}
