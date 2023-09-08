class User {
  final String email;
  final String firstName;
  final String lastName;
  final int yearsPlaying;
  String? instagram;
  String? supportTeamID;

  User(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.yearsPlaying,
      this.instagram,
      this.supportTeamID});
}
