import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/player_points.dart';
import 'package:kendamanomics_mobile/services/leaderboards_service.dart';
import 'package:kiwi/kiwi.dart';

enum LeaderboardsProviderState {
  loading,
  none,
  success,
  errorFetchingLeaderboard,
}

enum LeaderboardTab {
  kendamanomics,
  competition,
  overall,
}

class LeaderboardsProvider extends ChangeNotifier with LoggerMixin {
  final _leaderboardsService = KiwiContainer().resolve<LeaderboardsService>();
  final List<PlayerPoints> _kendamanomicsLeaderboard = [];
  final List<PlayerPoints> _competitionLeaderboard = [];
  final List<PlayerPoints> _overallLeaderboard = [];
  LeaderboardTab _activeLeaderboard = LeaderboardTab.kendamanomics;
  LeaderboardsProviderState _state = LeaderboardsProviderState.loading;
  PlayerPoints? _myPlayer;
  int _listLength = 0;

  LeaderboardTab get activeLeaderboard => _activeLeaderboard;
  LeaderboardsProviderState get state => _state;
  List<PlayerPoints> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<PlayerPoints> get competitionLeaderboard => _competitionLeaderboard;
  List<PlayerPoints> get overallLeaderboard => _overallLeaderboard;
  PlayerPoints? get myPlayer => _myPlayer;
  int get listLength => _listLength;

  LeaderboardsProvider() {
    fetchLeaderboardData(LeaderboardTab.kendamanomics);
    fetchMyKendamaStats();
  }

  List<dynamic> get leaderboardData {
    switch (_activeLeaderboard) {
      case LeaderboardTab.kendamanomics:
        return _kendamanomicsLeaderboard;
      case LeaderboardTab.competition:
        return _competitionLeaderboard;
      case LeaderboardTab.overall:
        return _overallLeaderboard;
    }
  }

  Future<void> fetchLeaderboardData(LeaderboardTab leaderboardType) async {
    try {
      List<PlayerPoints> data;
      switch (leaderboardType) {
        case LeaderboardTab.kendamanomics:
          data = await _leaderboardsService.fetchLeaderboardKendamanomicsPoints();
          _state = LeaderboardsProviderState.success;
          _listLength = data.length;
          _kendamanomicsLeaderboard.clear();
          _kendamanomicsLeaderboard.addAll(data);
          break;
        case LeaderboardTab.competition:
          data = await _leaderboardsService.fetchLeaderboardCompetitionPoints();
          _state = LeaderboardsProviderState.success;
          _listLength = data.length;
          _competitionLeaderboard.clear();
          _competitionLeaderboard.addAll(data);
          break;
        case LeaderboardTab.overall:
          data = await _leaderboardsService.fetchOverallPoints();
          _state = LeaderboardsProviderState.success;
          _listLength = data.length;
          _overallLeaderboard.clear();
          _overallLeaderboard.addAll(data);
          break;
      }
    } catch (e) {
      logE('Error fetching leaderboard data: $e');
      _state = LeaderboardsProviderState.errorFetchingLeaderboard;
    }
    notifyListeners();
  }

  Future<void> fetchMyKendamaStats() async {
    try {
      final myPositionData = await _leaderboardsService.fetchKendamanomicsLeaderboard();
      _myPlayer = myPositionData;
      _state = LeaderboardsProviderState.success;
    } catch (e) {
      logE('Error fetching user data: $e');
      _state = LeaderboardsProviderState.errorFetchingLeaderboard;
    }
    notifyListeners();
  }

  void setActiveLeaderboard(LeaderboardTab type) {
    _activeLeaderboard = type;
    _state = LeaderboardsProviderState.loading;
    notifyListeners();
    fetchLeaderboardData(type);
  }

  @override
  String get className => 'LeaderboardsProvider';
}