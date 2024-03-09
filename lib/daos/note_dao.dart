import 'package:drift/drift.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/models/note_model.dart';

part 'note_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  final AppDatabase db;
  NotesDao(this.db) : super(db);

  Future<List<Note>> listNote(int childId, String type) async {
    final result = await (select(db.notes)
          ..where((g) => g.childId.equals(childId))
          ..where((g) => g.type.equals(type))
          ..orderBy([(g) => OrderingTerm(expression: g.createdAt)]))
        .get();
    return result;
  }

  Future<void> deleteNote(Note note) async {
    await delete(db.notes).delete(note);
  }

  Future<void> createNote(
      {required int childId,
      required String type,
      required String note}) async {
    await into(db.notes).insert(NotesCompanion(
      note: Value(note),
      type: Value(type),
      childId: Value(childId),
    ));
  }

  Future<bool> updateNote(Note note) async {
    return update(db.notes).replace(note);
  }
}
