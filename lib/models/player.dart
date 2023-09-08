class Player {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final int yearsPlaying;
  String? instagram;
  String? supportTeamID;

  Player(
      {required this.email,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.yearsPlaying,
      this.instagram,
      this.supportTeamID});

  Player.empty({required this.id, required this.email})
      : firstName = '',
        lastName = '',
        yearsPlaying = -1,
        instagram = null,
        supportTeamID = null;

  Player copyWith({
    String? firstName,
    String? lastName,
    int? yearsPlaying,
    String? instagram,
    String? supportTeamID,
  }) {
    return Player(
      email: email,
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      yearsPlaying: yearsPlaying ?? this.yearsPlaying,
      instagram: instagram ?? this.instagram,
      supportTeamID: supportTeamID ?? this.supportTeamID,
    );
  }
}
