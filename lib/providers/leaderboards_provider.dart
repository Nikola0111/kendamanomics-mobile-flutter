import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';

class LeaderboardsProvider extends ChangeNotifier with LoggerMixin {
  String _selectedLeaderboard = 'kendamanomics';

  String get selectedLeaderboard => _selectedLeaderboard;

  void changeLeaderBoard(String newLeaderboard) {
    _selectedLeaderboard = newLeaderboard;
    notifyListeners();
  }

  @override
  String get className => 'LeaderboardsProvider';
}
