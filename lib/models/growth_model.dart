import 'package:drift/drift.dart';
import 'package:my_baby/models/child_model.dart';

class Growths extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Childs, #id)();
  RealColumn get weight => real()();
  RealColumn get height => real().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().unique().withDefault(currentDateAndTime)();
}
