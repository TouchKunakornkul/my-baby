import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/service/locator.dart';

class GrowthProvider extends ChangeNotifier {
  final AppDatabase _appDatabase = locator<AppDatabase>();
  List<Growth> growths = [];

  Future<List<Growth>> listGrowth() async {
    final result = await _appDatabase.select(_appDatabase.growths).get();
    growths = result;
    notifyListeners();
    return result;
  }
}
