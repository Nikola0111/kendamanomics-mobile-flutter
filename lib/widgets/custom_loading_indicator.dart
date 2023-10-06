import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(color: CustomColors.of(context).backgroundColor),
        ),
      ),
    );
  }
}
