class PlayerPoints {
  final int kendamanomicsPoints;
  final int competitionPoints;

  PlayerPoints({
    required this.kendamanomicsPoints,
    required this.competitionPoints,
  });

  factory PlayerPoints.fromJson({required Map<String, dynamic> json}) {
    return PlayerPoints(
      competitionPoints: json['leaderboard_competition_points'] ?? 234,
      kendamanomicsPoints: json['leaderboard_kendamanomics_points'] ?? 234,
    );
  }
}
