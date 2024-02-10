import 'package:drift/drift.dart';
import 'package:my_baby/daos/feeding_dao.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/daos/stock_dao.dart';
import 'package:my_baby/models/child_model.dart';
import 'package:my_baby/models/develop_model.dart';
import 'package:my_baby/models/feeding_model.dart';
import 'package:my_baby/models/growth_model.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:my_baby/models/note_model.dart';
import 'package:my_baby/models/poo_pee_model.dart';
import 'package:my_baby/models/stock_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// part 'feedings_dao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
// @DriftAccessor(tables: [Feedings])
// class FeedingsDao extends DatabaseAccessor<AppDatabase>
//     with _$FeedingsDaoMixin {
//   // this constructor is required so that the main database can create an instance
//   // of this object.
//   FeedingsDao(AppDatabase db) : super(db);
//   Future<List<Feeding>> listFeeding() {
//     return select(feedings).get();
//   }
// }

@DriftDatabase(
    tables: [Childs, Growths, Develops, Notes, Feedings, Stocks, PooPees],
    daos: [FeedingsDao, NotesDao, StocksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;
  Future<List<Growth>> listGrowth() {
    return select(growths).get();
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.alterTable(TableMigration(growths, columnTransformer: {
            growths.height: growths.height.cast<double>(),
          }));
        }
        if (from < 3) {
          await m.create(notes);
        }
        if (from < 4) {
          await m.create(feedings);
        }
        if (from < 5) {
          await customUpdate(
            "UPDATE feedings SET type = 'stock' WHERE type = 'bottle'",
            updates: {feedings},
          );
          await customUpdate(
            "UPDATE feedings SET type = 'powder' WHERE type = 'formula'",
            updates: {feedings},
          );
        }
        if (from < 6) {
          await m.create(stocks);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
