import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  bool notificationEnabled = true;

  AppProvider({
    required this.sharedPreferences,
    required this.notificationEnabled,
  });

  void setNotification(bool isOn) {
    notificationEnabled = isOn;
    sharedPreferences.setBool('notificationEnabled', isOn);
    notifyListeners();
  }
}
