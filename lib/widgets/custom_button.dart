import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? customTextColor;
  final bool isEnabled;
  final bool isLoading;
  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.customTextColor,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isEnabled ? 0.5 : 0.1),
            spreadRadius: -4,
            blurRadius: 7,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled) && !isLoading) return CustomColors.of(context).secondary;
              return CustomColors.of(context).primary;
            },
          ),
          overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.09)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          minimumSize: MaterialStateProperty.all<Size>(const Size(120, 80)),
          maximumSize: MaterialStateProperty.all<Size>(const Size(240, 80)),
        ),
        onPressed: isEnabled && !isLoading ? onPressed : null,
        child: Center(
          child: child ??
              Text(
                text!,
                style: CustomTextStyles.of(context).medium24.apply(color: _getButtonColor(context)),
              ),
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    if (isEnabled) {
      return customTextColor ?? CustomColors.of(context).backgroundColor;
    } else {
      return CustomColors.of(context).primaryText.withOpacity(0.6);
    }
  }
}
