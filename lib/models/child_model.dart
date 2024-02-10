import 'package:drift/drift.dart';

class Childs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn? get imageUrl => text().nullable()();
  DateTimeColumn? get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get createdAt => dateTime().withDefault(currentDateAndTime)();
}
