import 'package:kendamanomics_mobile/constants.dart';
import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tama {
  final String? id;
  final String? name;
  final String? imagePath;
  final String? tamasGroupID;
  final int? numOfTricks;
  final List<TamaTrickProgress>? tricks;
  String imageUrl;

  Tama({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.numOfTricks,
    required this.imageUrl,
    this.tamasGroupID,
    List<TamaTrickProgress>? tricks,
  }) : tricks = tricks ?? <TamaTrickProgress>[];

  factory Tama.fromJson({required Map<String, dynamic> json}) {
    final imageUrl = Supabase.instance.client.storage.from(kTamaImagesBucketID).getPublicUrl(json['tama_image_url']);
    return Tama(
      id: json['tama_id'],
      name: json['tama_name'],
      imagePath: json['tama_image_url'],
      imageUrl: imageUrl,
      numOfTricks: json['tama_number_of_tricks'],
      tamasGroupID: json['tama_group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tama_id': id,
      'tama_name': name,
      'tama_image_url': imagePath,
      'tama_number_of_tricks': numOfTricks,
      'tama_group_id': tamasGroupID,
    };
  }
}
