import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class PlayerEntry extends StatelessWidget {
  final VoidCallback onTap;
  final String? playerName;
  final int? points;
  final bool myPoints;
  final int? rank;
  const PlayerEntry({
    super.key,
    required this.onTap,
    required this.playerName,
    required this.points,
    this.myPoints = false,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            border: Border(bottom: myPoints ? BorderSide.none : BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3)))),
        child: Row(
          children: [
            if (myPoints) ...[
              Text(
                '$rank.',
                style: CustomTextStyles.of(context).regular16.apply(color: CustomColors.of(context).primary),
              ),
              const SizedBox(width: 4.0)
            ],
            Expanded(
              child: Text(
                playerName ?? '',
                style: CustomTextStyles.of(context)
                    .regular16
                    .apply(color: myPoints ? CustomColors.of(context).primary : CustomColors.of(context).primaryText),
              ),
            ),
            const SizedBox(width: 8.0),
            if (points != null) ...[
              Text(
                points.toString(),
                style: CustomTextStyles.of(context)
                    .regular16
                    .apply(color: myPoints ? CustomColors.of(context).primary : CustomColors.of(context).primaryText),
              ),
              const SizedBox(width: 8.0),
            ],
          ],
        ),
      ),
    );
  }
}
