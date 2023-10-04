class PlayerPoints {
  final int kendamanomicsPoints;
  final int competitionPoints;
  final int overallPoints;
  final String playerName;
  final String playerLastName;
  final int? rank;
  final String? playerId;

  PlayerPoints({
    required this.kendamanomicsPoints,
    required this.competitionPoints,
    required this.overallPoints,
    required this.playerName,
    required this.playerLastName,
    this.rank,
    this.playerId,
  });

  factory PlayerPoints.fromJson({required Map<String, dynamic> json}) {
    return PlayerPoints(
        competitionPoints: json['leaderboard_competition_points'] ?? 0,
        kendamanomicsPoints: json['leaderboard_kendamanomics_points'] ?? 0,
        overallPoints: json['leaderboard_overall_points'] ?? 0,
        playerName: json['player_firstname'] ?? 'default name',
        playerLastName: json['player_lastname'] ?? 'default last name',
        playerId: json['leaderboard_player_id'] ?? 'no player found');
  }
}
