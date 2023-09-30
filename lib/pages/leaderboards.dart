import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/providers/leaderboards_provider.dart';
import 'package:kendamanomics_mobile/widgets/leaderboard_type.dart';
import 'package:kendamanomics_mobile/widgets/leaderboards/competition_leaderboard.dart';
import 'package:kendamanomics_mobile/widgets/leaderboards/kendamanomics_leaderboard.dart';
import 'package:kendamanomics_mobile/widgets/leaderboards/overall_leaderboard.dart';
import 'package:provider/provider.dart';

class Leaderboards extends StatelessWidget {
  static const pageName = 'leaderboards';
  const Leaderboards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
        child: ChangeNotifierProvider(
          create: (context) => LeaderboardsProvider(),
          child: Consumer<LeaderboardsProvider>(
            builder: (context, provider, child) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LeaderboardType(
                      leaderboardName: 'kendamanomics',
                      color: CustomColors.of(context).primaryText,
                      onPressed: () {
                        provider.changeLeaderBoard('kendamanomics');
                      },
                      isActive: provider.selectedLeaderboard == 'kendamanomics',
                    ),
                    LeaderboardType(
                        leaderboardName: 'competition',
                        color: CustomColors.of(context).timelineColor,
                        onPressed: () {
                          provider.changeLeaderBoard('competition');
                        },
                        isActive: provider.selectedLeaderboard == 'competition'),
                    LeaderboardType(
                        leaderboardName: 'overall',
                        color: CustomColors.of(context).borderColor,
                        onPressed: () {
                          provider.changeLeaderBoard('overall');
                        },
                        isActive: provider.selectedLeaderboard == 'overall'),
                  ],
                ),
                Expanded(child: _getLeaderboard(provider.selectedLeaderboard))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLeaderboard(String leaderboardType) {
    switch (leaderboardType) {
      case 'kendamanomics':
        return const KendamanomicsLeaderboard();
      case 'competition':
        return const CompetitionLeaderboard();
      case 'overall':
        return const OverallLeaderboard();
      default:
        return const SizedBox.shrink();
    }
  }
}
