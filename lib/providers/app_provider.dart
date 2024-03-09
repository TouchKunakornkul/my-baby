import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/constants/share_preferences_constants.dart';
import 'package:my_baby/service/locator.dart';
import 'package:my_baby/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool notificationEnabled;
  final AppDatabase _appDatabase = locator<AppDatabase>();
  final NotificationService _notificationService =
      locator<NotificationService>();

  AppProvider({
    required this.notificationEnabled,
  });

  Future<void> setNotification(bool isOn) async {
    notificationEnabled = isOn;
    if (!isOn) {
      _notificationService.cancelAll();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final feedingHourDuration =
          prefs.getInt(SharedPreferencesConstants.feedingHourDuration);
      final feedingStartTime =
          prefs.getString(SharedPreferencesConstants.feedingStartTime);
      if (feedingHourDuration != null && feedingStartTime != null) {
        final startTime = DateTime.parse(feedingStartTime);
        await _notificationService.setRoutine(startTime, feedingHourDuration);
      }
    }
    notifyListeners();
  }

  Future<void> resetData() async {
    await _appDatabase.delete(_appDatabase.develops).go();
    await _appDatabase.delete(_appDatabase.growths).go();
    await _appDatabase.delete(_appDatabase.pooPees).go();
    await _appDatabase.delete(_appDatabase.stocks).go();
    await _appDatabase.delete(_appDatabase.feedings).go();
    await _appDatabase.delete(_appDatabase.notes).go();
    await _appDatabase.delete(_appDatabase.childs).go();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferencesConstants.onboarded, false);
  }
}
