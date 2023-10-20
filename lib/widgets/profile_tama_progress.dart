import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/providers/profile_page_provider.dart';
import 'package:kendamanomics_mobile/widgets/gif_loading_animation.dart';

class ProfileTamaProgress extends StatelessWidget {
  final ProfilePageState state;
  final List<PlayerTama> playerTamas;
  const ProfileTamaProgress({super.key, required this.state, required this.playerTamas});

  @override
  Widget build(BuildContext context) {
    if (state == ProfilePageState.waiting) {
      return const SizedBox(
        height: 128,
        width: 128,
        child: GifLoadingAnimation(),
      );
    }

    if (state == ProfilePageState.error) return Container();

    return GridView.builder(
      shrinkWrap: true,
      itemCount: playerTamas.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      playerTamas[index].tama.imageUrl,
                      width: constraints.maxWidth * 0.7,
                      height: constraints.maxWidth * 0.7,
                    ),
                    Text(
                      playerTamas[index].tama.tamaGroupName ?? '',
                      style: CustomTextStyles.of(context).regular14.apply(color: CustomColors.of(context).primary),
                    ),
                    Text(
                      playerTamas[index].tama.name ?? '',
                      style: CustomTextStyles.of(context).regular14.apply(color: CustomColors.of(context).primary),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: constraints.maxHeight - 87),
                  child: Image.asset(
                    'assets/icon/icon_trophy_completed.png',
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxWidth * 0.3,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
