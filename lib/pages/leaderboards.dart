import 'package:easy_localization/easy_localization.dart';
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
                      leaderboardName: 'leaderboards.kendamanomics'.tr(),
                      color: CustomColors.of(context).primaryText,
                      onPressed: () {
                        provider.setActiveLeaderboard(Leaderboard.kendamanomics);
                      },
                      isActive: provider.activeLeaderboard == Leaderboard.kendamanomics,
                    ),
                    LeaderboardType(
                        leaderboardName: 'leaderboards.competition'.tr(),
                        color: CustomColors.of(context).timelineColor,
                        onPressed: () {
                          provider.setActiveLeaderboard(Leaderboard.competition);
                        },
                        isActive: provider.activeLeaderboard == Leaderboard.competition),
                    LeaderboardType(
                        leaderboardName: 'leaderboards.overall'.tr(),
                        color: CustomColors.of(context).borderColor,
                        onPressed: () {
                          provider.setActiveLeaderboard(Leaderboard.overall);
                        },
                        isActive: provider.activeLeaderboard == Leaderboard.overall),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.listLength,
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
                      final playerName = () {
                        switch (provider.activeLeaderboard) {
                          case Leaderboard.kendamanomics:
                          case Leaderboard.competition:
                          case Leaderboard.overall:
                            if (leaderboardData.isNotEmpty) {
                              final player = leaderboardData[index];
                              final rankingNumber = index + 1;
                              return '$rankingNumber. ${player.playerName} ${player.playerLastName}';
                            } else {
                              return 'Unknown Player';
                            }
                          default:
                            return '';
                        }
                      }();
                      final points = () {
                        switch (provider.activeLeaderboard) {
                          case Leaderboard.kendamanomics:
                            return leaderboardData.isNotEmpty ? leaderboardData[index].kendamanomicsPoints : 0;
                          case Leaderboard.competition:
                            return leaderboardData.isNotEmpty ? leaderboardData[index].competitionPoints : 0;
                          case Leaderboard.overall:
                            return leaderboardData.isNotEmpty ? leaderboardData[index].overallPoints : 0;
                          default:
                            return 0;
                        }
                      }();
                      return PlayerEntry(
                        onTap: () => context.pushNamed(Profile.pageName),
                        playerName: playerName,
                        points: points,
                      );
                    },
                  ),
                ),
              ),
              provider.activeLeaderboard == Leaderboard.kendamanomics
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: provider.myList.isNotEmpty
                          ? PlayerEntry(
                              onTap: () {},
                              playerName: provider.myList[0].playerName,
                              points: provider.myList[0].kendamanomicsPoints,
                              myPoints: true,
                              rank: provider.myList[0].rank,
                            )
                          : const SizedBox.shrink(),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
