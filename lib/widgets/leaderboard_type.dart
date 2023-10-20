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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.27,
        child: ColoredBox(
          color: isActive ? CustomColors.of(context).selectedLeaderboard : color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Center(
              child: Text(
                overflow: TextOverflow.ellipsis,
                leaderboardName,
                maxLines: 1,
                style: getFontSize(context, leaderboardName).apply(
                  color: isActive ? CustomColors.of(context).primaryText : CustomColors.of(context).selectedLeaderboard,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle getFontSize(BuildContext context, String text) {
    double boxWidth = MediaQuery.of(context).size.width * 0.27;
    if (boxWidth > 110.0) {
      final customResize = CustomTextStyles.of(context).light16;
      return customResize;
    } else if (boxWidth < 102.0) {
      final customResize = CustomTextStyles.of(context).light15;
      return customResize;
    } else if (boxWidth <= 95.0) {
      final customResize = CustomTextStyles.of(context).light13;
      return customResize;
    } else if (boxWidth <= 89.0) {
      final customResize = CustomTextStyles.of(context).light12;
      return customResize;
    }
    return CustomTextStyles.of(context).light15;
  }
}
