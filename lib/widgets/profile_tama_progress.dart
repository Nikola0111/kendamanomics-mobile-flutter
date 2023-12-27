import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/models/tama.dart';
import 'package:kendamanomics_mobile/pages/tricks_page.dart';
import 'package:kendamanomics_mobile/providers/profile_page_provider.dart';
import 'package:kendamanomics_mobile/widgets/gif_loading_animation.dart';

class ProfileTamaProgress extends StatelessWidget {
  final ProfilePageState state;
  final List<PlayerTama> playerTamas;
  const ProfileTamaProgress(
      {super.key, required this.state, required this.playerTamas});

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
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          TricksPage.pageName,
                          extra: playerTamas[index].tama.id,
                        );
                      },
                      child: Image.network(
                        playerTamas[index].tama.imageUrl,
                        width: constraints.maxWidth * 0.7,
                        height: constraints.maxWidth * 0.7,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Image.asset(
                        'assets/icon/icon_trophy_default.png',
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxWidth * 0.3,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Text(
                //         getName(playerTamas[index].tama),
                //         textAlign: TextAlign.center,
                //         style: CustomTextStyles.of(context).regular14.apply(color: CustomColors.of(context).primary),
                //       ),
                //     ),
                //     SizedBox(width: constraints.maxWidth * 0.3, height: constraints.maxWidth * 0.3),
                //   ],
                // ),
              ],
            );
          },
        );
      },
    );
  }

  String getName(Tama tama) {
    return '${tama.tamaGroupName ?? ''} ${tama.name ?? ''}';
  }
}
