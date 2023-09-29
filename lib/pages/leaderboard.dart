import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/leaderboard_type.dart';
import 'package:kendamanomics_mobile/widgets/player_entry.dart';
import 'package:kiwi/kiwi.dart';

class Leaderboard extends StatelessWidget {
  static const pageName = 'leaderboard';
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeaderboardType(
                  leaderboardName: 'kendamanomics',
                  color: CustomColors.of(context).primaryText,
                  onPressed: () {},
                  isActive: true,
                ),
                LeaderboardType(
                  leaderboardName: 'competition',
                  color: CustomColors.of(context).primaryText,
                  onPressed: () {},
                  isActive: false,
                ),
                LeaderboardType(
                  leaderboardName: 'overall',
                  color: CustomColors.of(context).primaryText,
                  onPressed: () {},
                  isActive: false,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(), itemCount: 100, itemBuilder: (context, index) => PlayerEntry()),
            ),
          ],
        ),
      ),
      // child: CustomButton(
      //   text: 'logout',
      //   onPressed: () {
      //     KiwiContainer().resolve<AuthService>().signOut();
      //     context.goNamed(LoginPage.pageName);
      //   },
      // ),
    );
  }
}
