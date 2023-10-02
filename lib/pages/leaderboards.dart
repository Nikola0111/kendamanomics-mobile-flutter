import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/pages/profile.dart';
import 'package:kendamanomics_mobile/providers/leaderboards_provider.dart';
import 'package:kendamanomics_mobile/widgets/leaderboard_type.dart';
import 'package:kendamanomics_mobile/widgets/player_entry.dart';
import 'package:provider/provider.dart';

class Leaderboards extends StatelessWidget {
  static const pageName = 'leaderboards';
  const Leaderboards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: ChangeNotifierProvider(
        create: (context) => LeaderboardsProvider(),
        child: Consumer<LeaderboardsProvider>(
          builder: (context, provider, child) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LeaderboardType(
                      leaderboardName: 'kendamanomics', //add localization
                      color: CustomColors.of(context).primaryText,
                      onPressed: () {
                        provider.setActiveLeaderboard(Leaderboard.kendamanomics);
                      },
                      isActive: provider.activeLeaderboard == Leaderboard.kendamanomics,
                    ),
                    LeaderboardType(
                        leaderboardName: 'competition', //add localization
                        color: CustomColors.of(context).timelineColor,
                        onPressed: () {
                          provider.setActiveLeaderboard(Leaderboard.competition);
                        },
                        isActive: provider.activeLeaderboard == Leaderboard.competition),
                    LeaderboardType(
                        leaderboardName: 'overall', // add localization
                        color: CustomColors.of(context).borderColor,
                        onPressed: () {
                          provider.setActiveLeaderboard(Leaderboard.overall);
                        },
                        isActive: provider.activeLeaderboard == Leaderboard.overall),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: () {
                    switch (provider.activeLeaderboard) {
                      case Leaderboard.kendamanomics:
                        return provider.kendamanomicsLeaderboard.length;
                      case Leaderboard.competition:
                        return provider.competitionLeaderboard.length;
                      case Leaderboard.overall:
                        return provider.overallLeaderboard.length;
                      default:
                        return 0;
                    }
                  }(),
                  itemBuilder: (context, index) {
                    final leaderboardData = () {
                      switch (provider.activeLeaderboard) {
                        case Leaderboard.kendamanomics:
                          return provider.kendamanomicsLeaderboard;
                        case Leaderboard.competition:
                          return provider.competitionLeaderboard;
                        case Leaderboard.overall:
                          return provider.overallLeaderboard;
                        default:
                          return [];
                      }
                    }();
                    final playerName = leaderboardData.isNotEmpty ? leaderboardData[index]['playerName'] : '';
                    final points = leaderboardData.isNotEmpty ? leaderboardData[index]['points'] : null;
                    return PlayerEntry(
                      onTap: () => context.pushNamed(Profile.pageName),
                      playerName: playerName,
                      points: points,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
