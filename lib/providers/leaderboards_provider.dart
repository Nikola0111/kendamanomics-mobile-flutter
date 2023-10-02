import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/leaderboards_service.dart';
import 'package:kiwi/kiwi.dart';

enum Leaderboard {
  kendamanomics,
  competition,
  overall,
}

class LeaderboardsProvider extends ChangeNotifier with LoggerMixin {
  final _leaderboardsService = KiwiContainer().resolve<LeaderboardsService>();
  Leaderboard _activeLeaderboard = Leaderboard.kendamanomics;
  List<Map<String, dynamic>> _kendamanomicsLeaderboard = [];
  List<Map<String, dynamic>> _competitionLeaderboard = [];
  List<Map<String, dynamic>> _overallLeaderboard = [];

  Leaderboard get activeLeaderboard => _activeLeaderboard;
  List<Map<String, dynamic>> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<Map<String, dynamic>> get competitionLeaderboard => _competitionLeaderboard;
  List<Map<String, dynamic>> get overallLeaderboard => _overallLeaderboard;

  List<Map<String, dynamic>> get leaderboardData {
    switch (_activeLeaderboard) {
      case Leaderboard.kendamanomics:
        return _kendamanomicsLeaderboard;
      case Leaderboard.competition:
        return _competitionLeaderboard;
      case Leaderboard.overall:
        return _overallLeaderboard;
    }
  }

  void setActiveLeaderboard(Leaderboard type) {
    _activeLeaderboard = type;
    notifyListeners();
  }

  @override
  String get className => 'LeaderboardsProvider';
}
