import 'package:get_it/get_it.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/daos/feeding_dao.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/daos/stock_dao.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => FeedingsDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => NotesDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => StocksDao(locator<AppDatabase>()));
}
