import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/service/locator.dart';

class ChildProvider extends ChangeNotifier {
  final AppDatabase _appDatabase = locator<AppDatabase>();
  Child? child;

  Future<Child?> getChild() async {
    child = await _appDatabase.select(_appDatabase.childs).getSingleOrNull();
    notifyListeners();
    return child;
  }

  Future<void> updateChild({
    required name,
    required String imageUrl,
    required DateTime birthDate,
  }) async {
    await _appDatabase.into(_appDatabase.childs).insertOnConflictUpdate(
        ChildsCompanion.insert(
            id: const Value(1),
            name: name,
            birthDate: birthDate,
            imageUrl: Value(imageUrl)));
    getChild();
  }

  Future<void> deleteChild() async {
    await _appDatabase.delete(_appDatabase.childs).go();
    getChild();
  }
}
