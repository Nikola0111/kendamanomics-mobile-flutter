import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

enum IconPosition { leading, trailing }

class TextIconLink extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onPressed;
  final IconPosition iconPosition;
  const TextIconLink({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
    this.iconPosition = IconPosition.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPosition == IconPosition.leading) ...[
              icon,
              const SizedBox(width: 8),
            ],
            Text(title, style: CustomTextStyles.of(context).regular20),
            if (iconPosition == IconPosition.trailing) ...[
              const SizedBox(width: 8),
              icon,
            ],
          ],
        ),
      ),
    );
  }
}
