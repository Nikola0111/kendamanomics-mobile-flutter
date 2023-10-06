import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/pages/profile.dart';
import 'package:kendamanomics_mobile/providers/leaderboards_provider.dart';
import 'package:kendamanomics_mobile/widgets/leaderboard_type.dart';
import 'package:kendamanomics_mobile/widgets/player_entry.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                        provider.setActiveLeaderboard(LeaderboardTab.kendamanomics);
                      },
                      isActive: provider.activeLeaderboard == LeaderboardTab.kendamanomics,
                    ),
                    LeaderboardType(
                      leaderboardName: 'leaderboards.competition'.tr(),
                      color: CustomColors.of(context).timelineColor,
                      onPressed: () {
                        provider.setActiveLeaderboard(LeaderboardTab.competition);
                      },
                      isActive: provider.activeLeaderboard == LeaderboardTab.competition,
                    ),
                    LeaderboardType(
                      leaderboardName: 'leaderboards.overall'.tr(),
                      color: CustomColors.of(context).borderColor,
                      onPressed: () {
                        provider.setActiveLeaderboard(LeaderboardTab.overall);
                      },
                      isActive: provider.activeLeaderboard == LeaderboardTab.overall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: getList(context, provider),
                ),
              ),
              provider.activeLeaderboard == LeaderboardTab.kendamanomics && provider.myPlayer != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: PlayerEntry(
                        onTap: () {
                          context.pushNamed(Profile.pageName);
                        },
                        playerName: '${provider.myPlayer?.playerName} ${provider.myPlayer?.playerLastName}',
                        points: provider.myPlayer?.kendamanomicsPoints,
                        myPoints: true,
                        rank: provider.myPlayer?.rank,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmer(BuildContext context) {
    return Container(
      height: 19 + 2 * 16 - 0.5,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3)))),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 2 * 18,
            height: 19, // height of text
            child: Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.grey.withOpacity(0.5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 2 * 18,
                height: 19,
                child: Container(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getList(BuildContext context, LeaderboardsProvider provider) {
    if (provider.state == LeaderboardsProviderState.loading) {
      return Column(
        children: [
          _shimmer(context),
          _shimmer(context),
          _shimmer(context),
        ],
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: provider.listLength,
      itemBuilder: (context, index) {
        final leaderboardData = () {
          switch (provider.activeLeaderboard) {
            case LeaderboardTab.kendamanomics:
              return provider.kendamanomicsLeaderboard;
            case LeaderboardTab.competition:
              return provider.competitionLeaderboard;
            case LeaderboardTab.overall:
              return provider.overallLeaderboard;
            default:
              return [];
          }
        }();
        final playerName = () {
          switch (provider.activeLeaderboard) {
            case LeaderboardTab.kendamanomics:
            case LeaderboardTab.competition:
            case LeaderboardTab.overall:
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
            case LeaderboardTab.kendamanomics:
              return leaderboardData.isNotEmpty ? leaderboardData[index].kendamanomicsPoints : 0;
            case LeaderboardTab.competition:
              return leaderboardData.isNotEmpty ? leaderboardData[index].competitionPoints : 0;
            case LeaderboardTab.overall:
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
    );
  }
}
