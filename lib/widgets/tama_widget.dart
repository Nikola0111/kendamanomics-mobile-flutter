import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/extensions/string_extension.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:shimmer/shimmer.dart';

class TamaWidget extends StatelessWidget {
  final PlayerTama playerTama;
  const TamaWidget({super.key, required this.playerTama});

  @override
  Widget build(BuildContext context) {
    final scoreText = formatScore;
    final scoreSize = scoreText.calculateSize(CustomTextStyles.of(context).light20);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (playerTama.completedTricks != null)
              SizedBox(
                width: scoreSize.width,
                child: Text(scoreText, style: CustomTextStyles.of(context).light20),
              ),
            if (playerTama.completedTricks == null)
              SizedBox(
                width: scoreSize.width,
                height: scoreSize.height,
                child: Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: Colors.grey.withOpacity(0.5),
                  child: SizedBox(
                    width: scoreSize.width,
                    height: scoreSize.height,
                    child: Container(color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(width: 12),
            tamaImageWidget(context, tama: playerTama),
            const SizedBox(width: 12),
            // for some reason scoreSize.width on both sides doesn't center the tama
            // maybe the image itself has some padding
            const SizedBox(width: 4),
            if (playerTama.badgeType != null)
              Image.asset(
                'assets/icon/icon_trophy_completed.png',
                width: scoreSize.width,
              ),
            if (playerTama.badgeType == null) SizedBox(width: scoreSize.width),
          ],
        ),
        Text(
          playerTama.tama.name ?? 'default_titles.tama'.tr(),
          style: CustomTextStyles.of(context).light16,
        ),
      ],
    );
  }

  String get formatScore {
    return '${20}/${playerTama.tama.numOfTricks}';
  }

  Image tamaImageWidget(BuildContext context, {required PlayerTama tama}) {
    final size = MediaQuery.of(context).size.width * 0.4;
    if (playerTama.tama.imageUrl != null && playerTama.tama.imageUrl!.isNotEmpty) {
      return Image.network(playerTama.tama.imageUrl!, height: size, width: size);
    }
    return Image.asset('assets/images/birch_tama.png', height: size, width: size);
  }
}
