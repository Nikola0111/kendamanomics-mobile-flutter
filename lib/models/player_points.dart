class PlayerPoints {
  final int kendamanomicsPoints;
  final int competitionPoints;
  final String playerName;
  final String playerLastName;
  final int? rank;

  PlayerPoints({
    required this.kendamanomicsPoints,
    required this.competitionPoints,
    required this.playerName,
    required this.playerLastName,
    this.rank,
  });

  factory PlayerPoints.fromJson({required Map<String, dynamic> json}) {
    return PlayerPoints(
      competitionPoints: json['leaderboard_competition_points'] ?? 234,
      kendamanomicsPoints: json['leaderboard_kendamanomics_points'] ?? 234,
      playerName: json['player_firstname'] ?? 'randomName',
      playerLastName: json['player_lastname'] ?? 'randomName',
    );
  }
}
