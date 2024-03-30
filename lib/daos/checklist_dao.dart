import 'package:drift/drift.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/models/checklist_model.dart';

part 'checklist_dao.g.dart';

@DriftAccessor(tables: [Checklists])
class ChecklistsDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistsDaoMixin {
  ChecklistsDao(AppDatabase db) : super(db);

  Future<List<Checklist>> listChecklistByChildId(int childId) {
    return (select(db.checklists)..where((g) => g.childId.equals(childId)))
        .get();
  }

  updateChecklist(ChecklistsCompanion checklistsCompanion) {
    return into(db.checklists).insertOnConflictUpdate(checklistsCompanion);
  }
}
