import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';

class Tama {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? tamasGroupID;
  final int? numOfTricks;
  final List<TamaTrickProgress>? tricks;

  Tama({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.numOfTricks,
    this.tamasGroupID,
    List<TamaTrickProgress>? tricks,
  }) : tricks = tricks ?? <TamaTrickProgress>[];

  factory Tama.fromJson({required Map<String, dynamic> json}) {
    return Tama(
      id: json['tama_id'],
      name: json['tama_name'],
      imageUrl: json['tama_image_url'],
      numOfTricks: json['tama_number_of_tricks'],
      tamasGroupID: json['tama_group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tama_id': id,
      'tama_name': name,
      'tama_image_url': imageUrl,
      'tama_number_of_tricks': numOfTricks,
      'tama_group_id': tamasGroupID,
    };
  }
}
