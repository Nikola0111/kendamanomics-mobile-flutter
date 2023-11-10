import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/models/player_points.dart';

class Player {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final int yearsPlaying;
  String? playerImageUrl;
  String? instagram;
  PlayerPoints? playerPoints;
  String? companyID;
  Company? company;

  Player({
    required this.email,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.yearsPlaying,
    this.playerImageUrl,
    this.instagram,
    this.playerPoints,
    this.companyID,
    this.company,
  });

  Player.empty({required this.id, required this.email})
      : firstName = '',
        lastName = '',
        yearsPlaying = -1,
        instagram = null,
        playerImageUrl = null,
        playerPoints = null,
        companyID = null,
        company = null;

  Player copyWith({
    String? firstName,
    String? lastName,
    int? yearsPlaying,
    String? instagram,
    String? playerImageUrl,
    PlayerPoints? playerPoints,
    String? companyID,
    Company? company,
  }) {
    return Player(
      email: email,
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      yearsPlaying: yearsPlaying ?? this.yearsPlaying,
      instagram: instagram ?? this.instagram,
      playerImageUrl: playerImageUrl ?? this.playerImageUrl,
      playerPoints: playerPoints ?? this.playerPoints,
      companyID: companyID ?? this.companyID,
      company: company ?? this.company,
    );
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      email: json['player_email'] ?? '',
      id: json['player_id'] ?? '',
      firstName: json['player_firstname'] ?? '',
      lastName: json['player_lastname'] ?? '',
      yearsPlaying: json['player_years'] ?? 0,
      instagram: json['player_instagram'] ?? '',
      playerImageUrl: json['player_image_url'],
      playerPoints: PlayerPoints.fromJson(json: json),
      companyID: json['player_company_id'],
      company: json['player_company'] != null ? Company.fromJson(json: json['player_company']) : null,
    );
  }
}
