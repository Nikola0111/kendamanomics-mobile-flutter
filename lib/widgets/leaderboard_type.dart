import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class LeaderboardType extends StatelessWidget {
  final String leaderboardName;
  final Color color;
  final VoidCallback? onPressed;
  final bool isActive;
  final double fontSize;

  const LeaderboardType({
    super.key,
    required this.leaderboardName,
    required this.color,
    required this.isActive,
    required this.fontSize,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.27,
        child: ColoredBox(
          color: isActive ? CustomColors.of(context).selectedLeaderboard : color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Center(
              child: Text(
                overflow: TextOverflow.ellipsis,
                leaderboardName,
                maxLines: 1,
                style: CustomTextStyles.of(context).light16.copyWith(
                      color: isActive ? CustomColors.of(context).primaryText : CustomColors.of(context).selectedLeaderboard,
                      fontSize: fontSize,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
