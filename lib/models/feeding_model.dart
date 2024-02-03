import 'package:drift/drift.dart';
import 'package:my_baby/models/child_model.dart';

class Feedings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Childs, #id)();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  DateTimeColumn get feedTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get createdAt => dateTime().withDefault(currentDateAndTime)();
}
