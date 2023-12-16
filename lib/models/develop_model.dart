import 'package:drift/drift.dart';
import 'package:my_baby/models/child_model.dart';

class Develops extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Childs, #id)();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
