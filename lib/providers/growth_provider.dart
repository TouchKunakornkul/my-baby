import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/service/locator.dart';

class GrowthProvider extends ChangeNotifier {
  final AppDatabase _appDatabase = locator<AppDatabase>();
  List<Growth> growths = [];
  late int childId;

  double? get weight {
    return growths.lastOrNull?.weight;
  }

  double? get growthRate {
    if (growths.length < 2) return null;
    final current = growths.last;
    final previous = growths[growths.length - 2];
    final day = current.createdAt.difference(previous.createdAt).inDays;
    return (current.weight - previous.weight) *
        100 /
        previous.weight /
        (day > 0 ? day : 1);
  }

  Future<void> setChild(int id) async {
    childId = id;
    await listGrowth();
  }

  Future<List<Growth>> listGrowth() async {
    final result = await (_appDatabase.select(_appDatabase.growths)
          ..where((g) => g.childId.equals(childId))
          ..orderBy([(g) => OrderingTerm(expression: g.createdAt)]))
        .get();
    growths = result;
    notifyListeners();
    return result;
  }

  Future<void> addGrowth(
      {required double weight,
      required double? height,
      required DateTime createdAt}) async {
    await _appDatabase.into(_appDatabase.growths).insert(GrowthsCompanion(
          weight: Value(weight),
          height: Value(height),
          createdAt: Value(createdAt),
          childId: Value(childId),
        ));
    await listGrowth();
  }

  Future<void> edit(Growth growth, double? weight, double? height) async {
    await _appDatabase
        .update(_appDatabase.growths)
        .replace(growth.copyWith(weight: weight, height: Value(height)));
    await listGrowth();
  }
}
