import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final double angle;
  const TitleWidget({super.key, required this.title, required this.angle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Transform.rotate(
              angle: angle,
              child: Image.asset(
                'assets/icon/icon_arrow.png',
                alignment: Alignment.topLeft,
                height: 16.0,
                width: 16.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: CustomTextStyles.of(context).regular20.apply(color: CustomColors.of(context).primary),
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(width: 24),
      ],
    );
  }
}
