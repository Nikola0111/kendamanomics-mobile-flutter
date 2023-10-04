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
  List<PlayerPoints> _kendamanomicsLeaderboard = [];
  List<PlayerPoints> _competitionLeaderboard = [];
  List<PlayerPoints> _overallLeaderboard = [];
  String _playerName = '';
  String _playerLastname = '';
  int _playerPoints = 0;
  int _usersPosition = 0;
  int _listLength = 0;
  String _userId = '';

  Leaderboard get activeLeaderboard => _activeLeaderboard;
  List<PlayerPoints> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<PlayerPoints> get competitionLeaderboard => _competitionLeaderboard;
  List<PlayerPoints> get overallLeaderboard => _overallLeaderboard;
  String get playerName => _playerName;
  String get playerLastname => _playerLastname;
  int get playerPoints => _playerPoints;
  int get userPosition => _usersPosition;
  int get listLength => _listLength;
  String get userId => _userId;

  LeaderboardsProvider() {
    fetchLeaderboardData(Leaderboard.kendamanomics);
    fetchPlayerId();
    fetchUserInformationFromLeaderboard();
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

  void setActiveLeaderboard(Leaderboard type) {
    _activeLeaderboard = type;
    notifyListeners();
    fetchLeaderboardData(type);
  }

  Future<String?> fetchPlayerId() async {
    try {
      final id = await _authService.getCurrentUserId();
      _userId = id!;
      notifyListeners();
    } catch (e) {
      logE(e.toString());
    }

    return null;
  }

  Future<void> fetchUserInformationFromLeaderboard() async {
    try {
      final userData = await _leaderboardsService.fetchPlayerInfoById(_userId);

      if (userData != null) {
        _usersPosition = userData['position'];
        _playerName = userData['player_firstname'];
        _playerLastname = userData['player_lastname'];
        _playerPoints = userData['leaderboard_kendamanomics_points'];
      } else {
        _usersPosition = 0;
        _playerName = '';
        _playerLastname = '';
        _playerPoints = 0;
      }
    } catch (e) {
      print('Error fetching user information: $e');
      _usersPosition = 0;
      _playerName = '';
      _playerLastname = '';
      _playerPoints = 0;
    }
  }

  @override
  String get className => 'LeaderboardsProvider';
}
