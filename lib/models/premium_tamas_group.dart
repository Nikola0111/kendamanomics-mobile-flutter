import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/color_extension.dart';
import 'package:kendamanomics_mobile/models/tama.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';

class PremiumTamasGroup extends TamasGroup {
  final Color backgroundColor;
  final Color? textColor;
  final double price;
  final String videoUrl;

  PremiumTamasGroup({
    required TamasGroup tamasGroup,
    required this.backgroundColor,
    required this.textColor,
    required this.price,
    required this.videoUrl,
  }) : super(id: tamasGroup.id, name: tamasGroup.name, playerTamas: tamasGroup.playerTamas);

  factory PremiumTamasGroup.fromJson({required Map<String, dynamic> json, List<Tama>? tamas}) {
    final tamasGroup = TamasGroup.fromJson(json: json, tamas: tamas);
    final backgroundColor = Color(ColorExtension.formatStringForColorConstructor(json['background_color']));
    Color? textColor;
    if (json['text_color'] != null) {
      textColor = Color(ColorExtension.formatStringForColorConstructor(json['text_color']));
    }
    return PremiumTamasGroup(
      tamasGroup: tamasGroup,
      backgroundColor: backgroundColor,
      textColor: textColor,
      price: json['price'],
      videoUrl: json['video_url'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'tamas_group_id': id,
      'tamas_group_name': name,
      'background_color': backgroundColor.formatToString(),
      'text_color': textColor?.formatToString(),
      'price': price,
      'video_url': videoUrl,
    };
  }
}
