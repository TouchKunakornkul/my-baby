import 'package:flutter/foundation.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/daos/checklist_dao.dart';
import 'package:my_baby/service/locator.dart';
import 'package:drift/drift.dart';

const POO_PEE_NOTE_TYPE = "poo-pee";

class ChecklistProvider extends ChangeNotifier {
  final ChecklistsDao _checklistsDao = locator<ChecklistsDao>();
  List<Checklist> _checklist = [];

  List<Checklist> get checklist => _checklist;

  void reset() {
    _checklist = [];
    notifyListeners();
  }

  late int childId;

  Future<void> setChild(int id) async {
    childId = id;
    await fetchChecklist();
  }

  Future<void> fetchChecklist() async {
    final result = await _checklistsDao.listChecklistByChildId(childId);
    _checklist = result;
    notifyListeners();
  }

  Future<void> updateChecklist({
    required String key,
    required bool isChecked,
  }) async {
    await _checklistsDao.updateChecklist(ChecklistsCompanion(
      key: Value(key),
      isChecked: Value(isChecked),
      childId: Value(childId),
    ));
    await fetchChecklist();
  }
}
