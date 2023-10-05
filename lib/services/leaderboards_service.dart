import 'dart:async';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/player_points.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardsService with LoggerMixin {
  final _supabase = Supabase.instance.client;

  Future<List<PlayerPoints>> fetchLeaderboardKendamanomicsPoints() async {
    try {
      final response = await _supabase.rpc('get_leaderboard_kendamanomics_points');
      if (response != null) {
        final data = response as List<dynamic>;
        final leaderboardData = List<PlayerPoints>.from(data.map((points) {
          return PlayerPoints.fromJson(json: points as Map<String, dynamic>);
        }));
        return leaderboardData;
      } else {
        return [];
      }
    } catch (e) {
      logE('Error fetching leaderboard data: $e');
      return [];
    }
  }

  Future<List<PlayerPoints>> fetchLeaderboardCompetitionPoints() async {
    try {
      final response = await _supabase.rpc('get_leaderboard_competition_points');
      if (response != null) {
        final data = response as List<dynamic>;
        final leaderboardData = List<PlayerPoints>.from(data.map((points) {
          return PlayerPoints.fromJson(json: points as Map<String, dynamic>);
        }));
        return leaderboardData;
      }
      return [];
    } catch (e) {
      logE('Error fetching leaderboard data: $e');
      rethrow;
    }
  }

  Future<List<PlayerPoints>> fetchOverallPoints() async {
    try {
      final response = await _supabase.rpc('get_leaderboard_overall_points');
      if (response != null) {
        final data = response as List<dynamic>;
        final leaderboardData = List<PlayerPoints>.from(data.map((points) {
          return PlayerPoints.fromJson(json: points as Map<String, dynamic>);
        }));
        return leaderboardData;
      }
      return [];
    } catch (e) {
      logE('Error fetching leaderboard data: $e');
      rethrow;
    }
  }

  Future<List<PlayerPoints>> fetchKendamanomicsLeaderboard() async {
    try {
      final response = await _supabase.rpc('get_kendamanomics_leaderboard');
      if (response != null) {
        final data = response as List<dynamic>;
        final leaderboardData = List<PlayerPoints>.from(
          data.map(
            (points) {
              return PlayerPoints.fromJson(json: points as Map<String, dynamic>);
            },
          ),
        );
        return leaderboardData;
      }
      return [];
    } catch (e) {
      logE('Error fetching leaderboard data: $e');
      rethrow;
    }
  }

  @override
  String get className => 'LeaderboarsdServices';
}
