import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class DamxPoints extends StatelessWidget {
  final int damxPoints;
  const DamxPoints({
    super.key,
    required this.damxPoints,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: [
          SizedBox(
            height: 90,
            width: MediaQuery.of(context).size.width / 5.75,
            child: Image.asset(
              'assets/images/damx_points.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'profile_page.damx',
                  style: CustomTextStyles.of(context).regular16.apply(color: CustomColors.of(context).logLabel),
                ).tr(),
                Text(
                  'profile_page.points',
                  style: CustomTextStyles.of(context).regular16.apply(color: CustomColors.of(context).logLabel),
                ).tr(),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: CustomColors.of(context).borderColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text(
                      damxPoints.toString(),
                      style: TextStyle(color: CustomColors.of(context).logLabel),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
