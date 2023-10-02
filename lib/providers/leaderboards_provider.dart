import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/player_points.dart';
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
  List<PlayerPoints> _kendamanomicsLeaderboard = [];
  List<PlayerPoints> _competitionLeaderboard = [];
  List<Map<String, dynamic>> _overallLeaderboard = [];

  Leaderboard get activeLeaderboard => _activeLeaderboard;
  List<PlayerPoints> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<PlayerPoints> get competitionLeaderboard => _competitionLeaderboard;
  List<Map<String, dynamic>> get overallLeaderboard => _overallLeaderboard;

  List<dynamic> get leaderboardData {
    switch (_activeLeaderboard) {
      case Leaderboard.kendamanomics:
        return _kendamanomicsLeaderboard;
      case Leaderboard.competition:
        return _competitionLeaderboard;
      case Leaderboard.overall:
        return _overallLeaderboard;
    }
  }

  Future<void> fetchLeaderboardData(Leaderboard leaderboardType) async {
    try {
      List<PlayerPoints> data;
      switch (leaderboardType) {
        case Leaderboard.kendamanomics:
          data = await _leaderboardsService.fetchLeaderboardKendamanomicsPoints();
          _kendamanomicsLeaderboard.addAll(data);
          break;
        case Leaderboard.competition:
          data = await _leaderboardsService.fetchLeaderboardCompetitionPoints();
          _competitionLeaderboard.addAll(data);
          break;
        case Leaderboard.overall:
          break;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching leaderboard data: $e');
    }
  }

  void setActiveLeaderboard(Leaderboard type) {
    _activeLeaderboard = type;
    fetchLeaderboardData(type);
    notifyListeners();
  }

  @override
  String get className => 'LeaderboardsProvider';
}
