import 'package:get_it/get_it.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/daos/feeding_dao.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/daos/poo_pee_dao.dart';
import 'package:my_baby/daos/stock_dao.dart';
import 'package:my_baby/daos/checklist_dao.dart';
import 'package:my_baby/service/notification_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => FeedingsDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => NotesDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => StocksDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => PooPeesDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => ChecklistsDao(locator<AppDatabase>()));
  locator.registerLazySingleton(() => NotificationService());
}
