import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class LeaderboardType extends StatelessWidget {
  final String leaderboardName;
  final Color color;
  final VoidCallback onPressed;
  final bool isActive;

  const LeaderboardType({
    super.key,
    required this.leaderboardName,
    required this.color,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ColoredBox(
        color: isActive ? CustomColors.of(context).selectedLeaderboard : color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Center(
            child: Text(
              leaderboardName,
              style: CustomTextStyles.of(context).light16.apply(
                    color: isActive ? CustomColors.of(context).primaryText : CustomColors.of(context).selectedLeaderboard,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
