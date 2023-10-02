import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/leaderboards_service.dart';
import 'package:kiwi/kiwi.dart';

class LeaderboardsProvider extends ChangeNotifier with LoggerMixin {
  final _leaderboardsService = KiwiContainer().resolve<LeaderboarsdServices>();
  List<Map<String, dynamic>> _kendamanomicsLeaderboard = [];
  List<Map<String, dynamic>> _competitionLeaderboard = [];

  List<Map<String, dynamic>> get kendamanomicsLeaderboard => _kendamanomicsLeaderboard;
  List<Map<String, dynamic>> get competitionLeaderboard => _competitionLeaderboard;

  @override
  String get className => 'LeaderboardsProvider';
}
