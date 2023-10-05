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
  final List<PlayerPoints> _kendamanomicsLeaderboard = [];
  final List<PlayerPoints> _competitionLeaderboard = [];
  final List<PlayerPoints> _overallLeaderboard = [];
  Leaderboard _activeLeaderboard = Leaderboard.kendamanomics;
  PlayerPoints? _myPlayer;
  int _listLength = 0;

  Leaderboard get activeLeaderboard => _activeLeaderboard;
  List<PlayerPoints> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<PlayerPoints> get competitionLeaderboard => _competitionLeaderboard;
  List<PlayerPoints> get overallLeaderboard => _overallLeaderboard;
  PlayerPoints? get myPlayer => _myPlayer;
  int get listLength => _listLength;

  LeaderboardsProvider() {
    fetchLeaderboardData(Leaderboard.kendamanomics);
    fetchMyKendamaStats();
  }

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
          _listLength = data.length;

          _kendamanomicsLeaderboard.clear();
          _kendamanomicsLeaderboard.addAll(data);

          break;
        case Leaderboard.competition:
          data = await _leaderboardsService.fetchLeaderboardCompetitionPoints();
          _listLength = data.length;
          _competitionLeaderboard.clear();
          _competitionLeaderboard.addAll(data);
          break;
        case Leaderboard.overall:
          data = await _leaderboardsService.fetchOverallPoints();
          _listLength = data.length;
          _overallLeaderboard.clear();
          _overallLeaderboard.addAll(data);
          break;
      }
      notifyListeners();
    } catch (e) {
      logE('Error fetching leaderboard data: $e');
    }
  }

  Future<void> fetchMyKendamaStats() async {
    try {
      final myPositionData = await _leaderboardsService.fetchKendamanomicsLeaderboard();
      _myPlayer = myPositionData;
      notifyListeners();
    } catch (e) {
      logE('Error fetching user data: $e');
    }
  }

  void setActiveLeaderboard(Leaderboard type) {
    _activeLeaderboard = type;
    notifyListeners();
    fetchLeaderboardData(type);
  }

  @override
  String get className => 'LeaderboardsProvider';
}
