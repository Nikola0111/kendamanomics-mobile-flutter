import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboarsdServices with LoggerMixin {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchLeaderboardKendamanomicsPoints() async {
    try {
      final response = await _supabase.rpc('get_leaderboard_kendamanomics_points');
      if (response != null) {
        final data = response as List<dynamic>;
        final leaderboardData = data.map((points) {
          return {
            'created_at': points['created_at'],
            'leaderboard_player_id': points['leaderboard_player_id'],
            'leaderboard_kendamanomics_points': points['leaderboard_kendamanomics_points'],
            'leaderboard_competition_points': points['leaderboard_competition_points'],
          };
        }).toList();
        return leaderboardData;
      }
      return [];
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchLeaderboardCompetitionPoints() async {
    try {
      final response = await _supabase.rpc('get_leaderboard_competition_points');
      if (response != null) {
        final data = response as List<dynamic>;
        final leaderboardData = data.map((points) {
          return {
            'created_at': points['created_at'],
            'leaderboard_player_id': points['leaderboard_player_id'],
            'leaderboard_kendamanomics_points': points['leaderboard_kendamanomics_points'],
            'leaderboard_competition_points': points['leaderboard_competition_points'],
          };
        }).toList();
        return leaderboardData;
      }
      return [];
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      rethrow;
    }
  }

  @override
  String get className => 'LeaderboarsdServices';
}
