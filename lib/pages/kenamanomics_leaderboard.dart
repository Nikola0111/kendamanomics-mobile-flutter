import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/pages/competition_leaderboard.dart';
import 'package:kendamanomics_mobile/pages/overall_leaderboard.dart';
import 'package:kendamanomics_mobile/pages/profile.dart';
import 'package:kendamanomics_mobile/widgets/leaderboard_type.dart';
import 'package:kendamanomics_mobile/widgets/player_entry.dart';

class KendamanomicsLeaderboard extends StatelessWidget {
  static const pageName = 'kendamanomics_leaderboard';
  const KendamanomicsLeaderboard({super.key});

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
                  color: CustomColors.of(context).timelineColor,
                  onPressed: () => context.pushNamed(CompetitionLeaderboard.pageName),
                  isActive: false,
                ),
                LeaderboardType(
                  leaderboardName: 'overall',
                  color: CustomColors.of(context).borderColor,
                  onPressed: () => context.pushNamed(OverallLeaderboard.pageName),
                  isActive: false,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 100,
                itemBuilder: (context, index) => PlayerEntry(
                  onTap: () => context.pushNamed(Profile.pageName),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
