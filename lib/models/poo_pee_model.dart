import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_baby/models/child_model.dart';

class PooPees extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Childs, #id)();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

enum PooPeeType { poo, pee, both }

PooPeeType stringToPooPeeType(String type) {
  switch (type) {
    case 'poo':
      return PooPeeType.poo;
    case 'pee':
      return PooPeeType.pee;
    case 'both':
      return PooPeeType.both;
    default:
      throw Exception('Invalid feeding type');
  }
}

extension FeedingTypeExtension on PooPeeType {
  String get name {
    switch (this) {
      case PooPeeType.poo:
        return 'poo';
      case PooPeeType.pee:
        return 'pee';
      case PooPeeType.both:
        return 'both';
    }
  }

  String get label {
    switch (this) {
      case PooPeeType.poo:
        return 'poo_pee.type.poo'.tr();
      case PooPeeType.pee:
        return 'poo_pee.type.pee'.tr();
      case PooPeeType.both:
        return 'poo_pee.type.both'.tr();
    }
  }
}
