import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/player_points.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/leaderboards_service.dart';
import 'package:kiwi/kiwi.dart';

enum Leaderboard {
  kendamanomics,
  competition,
  overall,
}

class LeaderboardsProvider extends ChangeNotifier with LoggerMixin {
  final _leaderboardsService = KiwiContainer().resolve<LeaderboardsService>();
  final _authService = KiwiContainer().resolve<AuthService>();
  Leaderboard _activeLeaderboard = Leaderboard.kendamanomics;
  final List<PlayerPoints> _kendamanomicsLeaderboard = [];
  final List<PlayerPoints> _competitionLeaderboard = [];
  final List<PlayerPoints> _overallLeaderboard = [];
  String _playerName = '';
  String _playerLastname = '';
  int _playerPoints = 0;
  int _usersPosition = 0;
  int _listLength = 0;
  final List<PlayerPoints> _kendamanomicsData = [];

  Leaderboard get activeLeaderboard => _activeLeaderboard;
  List<PlayerPoints> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<PlayerPoints> get competitionLeaderboard => _competitionLeaderboard;
  List<PlayerPoints> get overallLeaderboard => _overallLeaderboard;
  String get playerName => _playerName;
  String get playerLastname => _playerLastname;
  int get playerPoints => _playerPoints;
  int get userPosition => _usersPosition;
  int get listLength => _listLength;
  List<PlayerPoints> get kendamanomicsData => _kendamanomicsData;

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

  Future<List<PlayerPoints>> fetchMyKendamaStats() async {
    try {
      final userData = await _leaderboardsService.fetchKendamanomicsLeaderboard();
      _kendamanomicsData.addAll(userData);

      final currentUserId = await _authService.getCurrentUserId();

      int playerPosition = 0;

      for (int i = 0; i < userData.length; i++) {
        final playerPoints = userData[i];

        if (currentUserId != null && playerPoints.playerId == currentUserId) {
          _playerName = playerPoints.playerName;
          _playerLastname = playerPoints.playerLastName;
          _playerPoints = playerPoints.kendamanomicsPoints;
          _usersPosition = playerPosition + 1;
        }
      }
      notifyListeners();
      return userData;
    } catch (e) {
      logE('Error fetching user data: $e');
      return <PlayerPoints>[];
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
