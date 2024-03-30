import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/service/locator.dart';

const GROWTH_NOTE_TYPE = 'growth';

class GrowthProvider extends ChangeNotifier {
  final AppDatabase _appDatabase = locator<AppDatabase>();
  final NotesDao _notesDao = locator<NotesDao>();
  List<Growth> growths = [];
  late int childId;
  List<Note> notes = [];

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

  double? get lastGrowthWeight {
    return growths
        .sorted((a, b) => a.createdAt.compareTo(b.createdAt))
        .lastOrNull
        ?.weight;
  }

  void reset() {
    growths = [];
    notes = [];
    notifyListeners();
  }

  Future<void> setChild(int id) async {
    childId = id;
    await listGrowth();
    await listGrowthNote();
  }

  Future<List<Growth>> listGrowth() async {
    final result = await (_appDatabase.select(_appDatabase.growths)
          ..where((g) => g.childId.equals(childId))
          ..orderBy([
            (g) =>
                OrderingTerm(expression: g.createdAt, mode: OrderingMode.desc)
          ]))
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

  Future<void> edit(
      Growth growth, double? weight, double? height, DateTime createdAt) async {
    await _appDatabase.update(_appDatabase.growths).replace(growth.copyWith(
        weight: weight, height: Value(height), createdAt: createdAt));
    await listGrowth();
  }

  Future<List<Note>> listGrowthNote() async {
    final result = await (_appDatabase.select(_appDatabase.notes)
          ..where((g) => g.childId.equals(childId))
          ..where((g) => g.type.equals(GROWTH_NOTE_TYPE))
          ..orderBy([(g) => OrderingTerm(expression: g.createdAt)]))
        .get();
    notes = result;
    notifyListeners();
    return result;
  }

  Future<void> addGrowthNote({required String note}) async {
    await _appDatabase.into(_appDatabase.notes).insert(NotesCompanion(
          note: Value(note),
          type: const Value(GROWTH_NOTE_TYPE),
          childId: Value(childId),
        ));
    await listGrowthNote();
  }

  Future<void> deleteGrowthNote(Note note) async {
    await _notesDao.deleteNote(note);
    await listGrowthNote();
  }

  Future<void> updateGrowthNote(Note note) async {
    await _notesDao.updateNote(note);
    await listGrowthNote();
  }
}
