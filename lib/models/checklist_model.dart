import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:my_baby/models/child_model.dart';

class Checklists extends Table {
  TextColumn get key => text()();
  IntColumn get childId => integer().references(Childs, #id)();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key, childId};
}
