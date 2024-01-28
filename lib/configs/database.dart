import 'package:drift/drift.dart';
import 'package:my_baby/models/child_model.dart';
import 'package:my_baby/models/develop_model.dart';
import 'package:my_baby/models/growth_model.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:my_baby/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(tables: [Childs, Growths, Develops, Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;
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
          await m.createAll();
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
