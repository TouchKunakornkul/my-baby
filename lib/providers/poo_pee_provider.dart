import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/daos/poo_pee_dao.dart';
import 'package:my_baby/models/poo_pee_model.dart';
import 'package:my_baby/service/locator.dart';
import 'package:collection/collection.dart';

const POO_PEE_NOTE_TYPE = "poo-pee";

class PooPeeProvider extends ChangeNotifier {
  final PooPeesDao _pooPeesDao = locator<PooPeesDao>();
  final NotesDao _notesDao = locator<NotesDao>();
  List<PooPee> _pooPees = [];
  List<Note> _notes = [];

  List<PooPee> get pooPees => _pooPees;
  List<Note> get notes => _notes;

  void reset() {
    _pooPees = [];
    _notes = [];
    notifyListeners();
  }

  int get pooCount => _pooPees
      .where((element) =>
          stringToPooPeeType(element.type) == PooPeeType.poo ||
          stringToPooPeeType(element.type) == PooPeeType.both)
      .length;

  int get peeCount => _pooPees
      .where((element) =>
          stringToPooPeeType(element.type) == PooPeeType.pee ||
          stringToPooPeeType(element.type) == PooPeeType.both)
      .length;

  double get averagePoosPerDay {
    final days = pooPeesByDay.keys.length;
    if (days == 0) return 0;
    return pooCount / days;
  }

  Map<DateTime, List<PooPee>> get pooPeesByDay {
    return groupBy(_pooPees, (PooPee pooPee) {
      return DateTime(
        pooPee.createdAt.year,
        pooPee.createdAt.month,
        pooPee.createdAt.day,
      );
    });
  }

  late int childId;

  Future<void> setChild(int id) async {
    childId = id;
    await fetchPooPees();
    await fetchPooPeeNotes();
  }

  Future<List<PooPee>> fetchPooPees() async {
    _pooPees = await _pooPeesDao.listPooPee(childId);
    notifyListeners();
    return _pooPees;
  }

  Future<void> addPooPee({
    required DateTime createdAt,
    required PooPeeType type,
  }) async {
    await _pooPeesDao.createPooPee(PooPeesCompanion(
      type: Value(type.name),
      childId: Value(childId),
      createdAt: Value(createdAt),
    ));
    fetchPooPees();
  }

  Future<void> updatePooPee(PooPee pooPee) async {
    await _pooPeesDao.updatePooPee(pooPee.copyWith(updatedAt: DateTime.now()));
    fetchPooPees();
  }

  Future<void> deletePooPee(PooPee pooPee) async {
    await _pooPeesDao.deletePooPee(pooPee);
    fetchPooPees();
  }

  Future<List<Note>> fetchPooPeeNotes() async {
    _notes = await _notesDao.listNote(childId, POO_PEE_NOTE_TYPE);
    notifyListeners();
    return _notes;
  }

  Future<void> addPooPeeNote(String note) async {
    await _notesDao.createNote(
      childId: childId,
      type: POO_PEE_NOTE_TYPE,
      note: note,
    );
    fetchPooPeeNotes();
  }

  Future<void> deletePooPeeNote(Note note) async {
    await _notesDao.deleteNote(note);
    fetchPooPeeNotes();
  }

  Future<void> updatePooPeeNote(Note note) async {
    await _notesDao.updateNote(note);
    fetchPooPeeNotes();
  }
}
