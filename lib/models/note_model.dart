import 'package:drift/drift.dart';
import 'package:my_baby/models/child_model.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Childs, #id)();
  TextColumn get note => text()();
  TextColumn get type => text()();
  DateTimeColumn? get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get createdAt => dateTime().withDefault(currentDateAndTime)();
}
