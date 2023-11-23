import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class ClickableLink extends StatelessWidget {
  final String clickableText;
  final VoidCallback onTap;
  final TextStyle? clickableTextStyle;
  const ClickableLink({
    super.key,
    required this.clickableText,
    required this.onTap,
    this.clickableTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(clickableText, style: clickableTextStyle ?? CustomTextStyles.of(context).light24),
      ),
    );
  }
}
