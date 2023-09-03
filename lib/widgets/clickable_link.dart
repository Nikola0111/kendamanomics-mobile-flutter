import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class ClickableLink extends StatelessWidget {
  final String clickableText;
  final String? nonclickableText;
  final VoidCallback onClick;
  final TextStyle? clickableTextStyle;
  const ClickableLink({
    super.key,
    required this.clickableText,
    required this.onClick,
    this.nonclickableText,
    this.clickableTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          if (nonclickableText != null)
            TextSpan(
              text: '$nonclickableText ',
              style: CustomTextStyles.of(context).light24Opacity,
            ),
          TextSpan(
            text: clickableText,
            style: clickableTextStyle ?? CustomTextStyles.of(context).light24,
            recognizer: TapGestureRecognizer()..onTap = onClick,
            mouseCursor: SystemMouseCursors.click,
          ),
        ],
      ),
    );
  }
}
