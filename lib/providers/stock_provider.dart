import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/constants/share_preferences_constants.dart';
import 'package:my_baby/daos/stock_dao.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/service/locator.dart';
import 'package:collection/collection.dart';
import 'package:my_baby/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const STOCK_NOTE_TYPE = 'stock';

class StockProvider extends ChangeNotifier {
  final NotificationService _notificationService =
      locator<NotificationService>();
  final StocksDao _stocksDao = locator<StocksDao>();
  final NotesDao _notesDao = locator<NotesDao>();
  List<Stock> _stocks = [];
  List<Note> notes = [];

  DateTime? startTime;
  int? hourDuration;

  late int childId;

  List<Stock> get showedStocks =>
      _stocks.where((element) => element.amount > 0).toList();
  List<Note> get stockNotes => notes;

  double get availableStock {
    return _stocks.fold(0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  int get daysSaved {
    return availableStock ~/ 30; // mock
  }

  void reset() {
    _stocks = [];
    notes = [];
    notifyListeners();
  }

  Future<void> setChild(int id) async {
    childId = id;
    await fetchStocks();
    await fetchStockNotes();
  }

  Map<DateTime, List<Stock>> get stocksByDay {
    return groupBy(showedStocks, (Stock stock) {
      return DateTime(
        stock.createdAt.year,
        stock.createdAt.month,
        stock.createdAt.day,
      );
    });
  }

  Future<List<Stock>> fetchStocks() async {
    _stocks = await _stocksDao.listStock(childId);
    notifyListeners();
    return showedStocks;
  }

  Future<void> addStock({
    required DateTime createdAt,
    required double amount,
  }) async {
    await _stocksDao.createStock(StocksCompanion(
      amount: Value(amount),
      childId: Value(childId),
      createdAt: Value(createdAt),
    ));
    fetchStocks();
  }

  Future<void> updateStock(Stock stock) async {
    await _stocksDao.updateStock(stock.copyWith(updatedAt: DateTime.now()));
    fetchStocks();
  }

  Future<void> deleteStock(Stock stock) async {
    await _stocksDao.deleteStock(stock);
    fetchStocks();
  }

  Future<List<Note>> fetchStockNotes() async {
    notes = await _notesDao.listNote(childId, STOCK_NOTE_TYPE);
    notifyListeners();
    return notes;
  }

  Future<void> addStockNote(String note) async {
    await _notesDao.createNote(
      childId: childId,
      type: STOCK_NOTE_TYPE,
      note: note,
    );
    fetchStockNotes();
  }

  Future<void> deleteStockNote(Note note) async {
    await _notesDao.deleteNote(note);
    await fetchStockNotes();
  }

  Future<void> updateStockNote(Note note) async {
    await _notesDao.updateNote(note);
    await fetchStockNotes();
  }

  Future<void> setNotification(DateTime start, int hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPreferencesConstants.stockHourDuration, hour);
    await prefs.setString(
        SharedPreferencesConstants.stockStartTime, start.toIso8601String());
    await _notificationService.setRoutine(start, hour);

    startTime = start;
    hourDuration = hour;
    notifyListeners();
  }
}
