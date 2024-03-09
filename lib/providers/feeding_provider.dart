import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/constants/share_preferences_constants.dart';
import 'package:my_baby/daos/feeding_dao.dart';
import 'package:my_baby/daos/note_dao.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/service/locator.dart';
import 'package:collection/collection.dart';
import 'package:my_baby/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FeedingType { breast, stock, powder }

const FEEDING_NOTE_TYPE = 'feeding';

FeedingType stringToFeedingType(String type) {
  switch (type) {
    case 'breast':
      return FeedingType.breast;
    case 'stock':
      return FeedingType.stock;
    case 'powder':
      return FeedingType.powder;
    default:
      throw Exception('Invalid feeding type');
  }
}

extension FeedingTypeExtension on FeedingType {
  String get name {
    switch (this) {
      case FeedingType.breast:
        return 'breast';
      case FeedingType.stock:
        return 'stock';
      case FeedingType.powder:
        return 'powder';
    }
  }

  String get label {
    switch (this) {
      case FeedingType.breast:
        return 'feeding.type.breast'.tr();
      case FeedingType.stock:
        return 'feeding.type.stock'.tr();
      case FeedingType.powder:
        return 'feeding.type.powder'.tr();
    }
  }

  IconData get icon {
    switch (this) {
      case FeedingType.breast:
        return CustomIcons.feeding;
      case FeedingType.stock:
        return CustomIcons.bottle;
      case FeedingType.powder:
        return CustomIcons.spoon;
    }
  }

  double get iconSize {
    switch (this) {
      case FeedingType.breast:
        return 19;
      case FeedingType.stock:
        return 16;
      case FeedingType.powder:
        return 14;
    }
  }
}

class FeedingProvider extends ChangeNotifier {
  late StockProvider _stockProvider;
  final FeedingsDao _feedingDao = locator<FeedingsDao>();
  final NotesDao _notesDao = locator<NotesDao>();
  final NotificationService _notificationService =
      locator<NotificationService>();
  List<Feeding> _feedings = [];
  List<Note> notes = [];
  DateTime? startTime;
  int? hourDuration;

  late int childId;

  FeedingProvider({
    this.startTime,
    this.hourDuration,
  });

  List<Feeding> get feedings => _feedings;
  List<Note> get feedingNotes => notes;

  DateTime? get nextFeedingTime {
    if (startTime == null || hourDuration == null) {
      return null;
    }
    final now = DateTime.now();
    var feedingTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime!.hour,
      startTime!.minute,
    );
    while (feedingTime.isBefore(now)) {
      feedingTime = feedingTime.add(Duration(hours: hourDuration!));
    }
    return feedingTime;
  }

  void reset() {
    _feedings = [];
    notes = [];
    notifyListeners();
  }

  void update(StockProvider stockProvider) {
    _stockProvider = stockProvider;
  }

  Future<void> setChild(int id) async {
    childId = id;
    await fetchFeedings();
    await fetchFeedingNotes();
  }

  Map<DateTime, List<Feeding>> get feedingsByDay {
    return groupBy(_feedings, (Feeding feeding) {
      return DateTime(
        feeding.feedTime.year,
        feeding.feedTime.month,
        feeding.feedTime.day,
      );
    });
  }

  double get averageAmountPerDay {
    if (_feedings.isEmpty) return 0;
    final totalAmount = _feedings.map((e) => e.amount).reduce((a, b) => a + b);
    final days = _feedings
        .map((e) => e.feedTime)
        .map((e) => DateTime(e.year, e.month, e.day))
        .toSet()
        .length;
    return totalAmount / days;
  }

  set feedings(List<Feeding> feedings) {
    _feedings = feedings;
    notifyListeners();
  }

  Future<List<Feeding>> fetchFeedings() async {
    feedings = await _feedingDao.listFeedingByChildId(childId);
    notifyListeners();
    return feedings;
  }

  Future<void> addFeeding({
    required DateTime feedTime,
    required double amount,
    required FeedingType type,
  }) async {
    await _feedingDao.createFeeding(FeedingsCompanion(
      feedTime: Value(feedTime),
      amount: Value(amount),
      type: Value(type.name),
      childId: Value(childId),
    ));
    final availableStock = _stockProvider.availableStock;
    if (type == FeedingType.stock && availableStock > 0) {
      await _stockProvider.addStock(
        createdAt: feedTime,
        amount: -(amount > availableStock ? availableStock : amount),
      );
    }
    fetchFeedings();
  }

  Future<void> updateFeeding(Feeding feeding) async {
    await _feedingDao
        .updateFeeding(feeding.copyWith(updatedAt: DateTime.now()));
    fetchFeedings();
  }

  Future<void> deleteFeeding(Feeding feeding) async {
    await _feedingDao.deleteFeeding(feeding);
    fetchFeedings();
  }

  Future<List<Note>> fetchFeedingNotes() async {
    notes = await _notesDao.listNote(childId, FEEDING_NOTE_TYPE);
    notifyListeners();
    return notes;
  }

  Future<void> addFeedingNote(String note) async {
    await _notesDao.createNote(
      childId: childId,
      type: FEEDING_NOTE_TYPE,
      note: note,
    );
    fetchFeedingNotes();
  }

  Future<void> setNotification(DateTime start, int hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPreferencesConstants.feedingHourDuration, hour);
    await prefs.setString(
        SharedPreferencesConstants.feedingStartTime, start.toIso8601String());
    await _notificationService.setRoutine(start, hour);
    startTime = start;
    hourDuration = hour;
    notifyListeners();
  }
}
