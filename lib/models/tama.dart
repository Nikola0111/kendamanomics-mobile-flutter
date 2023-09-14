import 'package:kendamanomics_mobile/models/trick.dart';

class Tama {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? tamasGroupID;
  final int? numOfTricks;
  final List<Trick> tricks;

  Tama({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.numOfTricks,
    this.tamasGroupID,
    List<Trick>? tricks,
  }) : tricks = tricks ?? <Trick>[];

  factory Tama.fromJson({required Map<String, dynamic> json}) {
    return Tama(
        id: json['tama_id'],
        name: json['tama_name'],
        imageUrl: json['tama_image_url'],
        numOfTricks: json['tama_number_of_tricks'],
        tamasGroupID: json['tama_group_id']);
  }
}
