import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/extensions/string_extension.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/providers/tamas_provider.dart';
import 'package:shimmer/shimmer.dart';

class TamaWidget extends StatelessWidget {
  final PlayerTama playerTama;
  final TamasProviderState state;
  final VoidCallback onTap;
  const TamaWidget({super.key, required this.playerTama, required this.onTap, required this.state});

  @override
  Widget build(BuildContext context) {
    final scoreText = formatScore;
    final scoreSize = '20/20'.calculateSize(CustomTextStyles.of(context).light20);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state == TamasProviderState.success)
              SizedBox(
                width: scoreSize.width,
                child: Text(scoreText, style: CustomTextStyles.of(context).light20),
              ),
            if (state == TamasProviderState.loading)
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
            if ([TamasProviderState.errorFetchingProgress, TamasProviderState.none].contains(state))
              SizedBox(
                width: scoreSize.width,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(playerTama.tama.numOfTricks.toString(), style: CustomTextStyles.of(context).light20),
                ),
              ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onTap,
              child: tamaImageWidget(context, tama: playerTama),
            ),
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
    return '${playerTama.completedTricks}/${playerTama.tama.numOfTricks}';
  }

  Image tamaImageWidget(BuildContext context, {required PlayerTama tama}) {
    final size = MediaQuery.of(context).size.width * 0.4;
    if (playerTama.tama.imageUrl != null && playerTama.tama.imageUrl!.isNotEmpty) {
      return Image.asset(playerTama.tama.imageUrl!, height: size, width: size);
    }
    return Image.asset('assets/images/birch_tama.png', height: size, width: size);
  }
}
