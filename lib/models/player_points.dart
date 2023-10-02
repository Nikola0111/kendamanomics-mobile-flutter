class PlayerPoints {
  final DateTime createdAt;
  final String playerId;
  final int kendamanomicsPoints;
  final int competitionPoints;

  PlayerPoints({
    required this.createdAt,
    required this.playerId,
    required this.kendamanomicsPoints,
    required this.competitionPoints,
  });

  factory PlayerPoints.fromJson(Map<String, dynamic> json) {
    return PlayerPoints(
      competitionPoints: json['leaderboard_competition_points'],
      createdAt: json['created_at'],
      kendamanomicsPoints: json['leaderboard_kendamanomics_points'],
      playerId: json['leaderboard_player_id'],
    );
  }
}
