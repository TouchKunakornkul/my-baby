import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/service/locator.dart';
import 'package:collection/collection.dart';

class DevelopProvider extends ChangeNotifier {
  final AppDatabase _appDatabase = locator<AppDatabase>();
  Develop? muscle;
  Develop? brain;
  Develop? people;
  Develop? emotion;

  Future<List<Develop>> listDevelops() async {
    final result = await _appDatabase.select(_appDatabase.develops).get();
    muscle = result.firstWhereOrNull((element) => element.name == 'muscle');
    brain = result.firstWhereOrNull((element) => element.name == 'brain');
    people = result.firstWhereOrNull((element) => element.name == 'people');
    emotion = result.firstWhereOrNull((element) => element.name == 'emotion');
    notifyListeners();
    return result;
  }

  Future<void> removeAll() async {
    await (_appDatabase.delete(_appDatabase.develops)
          ..where((t) => t.id.isNotNull()))
        .go();
  }

  Future<void> updateDevelop({
    bool muscle = false,
    bool brain = false,
    bool people = false,
    bool emotion = false,
  }) async {
    await _appDatabase.batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(_appDatabase.develops, [
        if (muscle) DevelopsCompanion.insert(childId: 1, name: 'muscle'),
        if (brain) DevelopsCompanion.insert(childId: 1, name: 'brain'),
        if (people) DevelopsCompanion.insert(childId: 1, name: 'people'),
        if (emotion) DevelopsCompanion.insert(childId: 1, name: 'emotion'),
      ]);
    });
    listDevelops();
  }
}
