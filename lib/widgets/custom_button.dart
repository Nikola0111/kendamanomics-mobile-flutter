import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/widgets/custom_loading_indicator.dart';

enum CustomButtonStyle { big, small }

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? customTextColor;
  final bool isEnabled;
  final bool isLoading;
  final CustomButtonStyle buttonStyle;
  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.customTextColor,
    this.isEnabled = true,
    this.isLoading = false,
    this.buttonStyle = CustomButtonStyle.big,
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
              return _backgroundColor(context);
            },
          ),
          overlayColor: MaterialStateProperty.all<Color>(_splashColor(context)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          ),
          minimumSize: MaterialStateProperty.all<Size>(Size(120, _height)),
          maximumSize: MaterialStateProperty.all<Size>(Size(_width, _height)),
        ),
        onPressed: isEnabled && !isLoading ? onPressed : null,
        child: Center(child: _getChild(context)),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    if (isEnabled) {
      switch (buttonStyle) {
        case CustomButtonStyle.big:
          return CustomColors.of(context).backgroundColor;
        case CustomButtonStyle.small:
          return CustomColors.of(context).deniedColor;
      }
    } else {
      return CustomColors.of(context).primaryText.withOpacity(0.6);
    }
  }

  Widget _getChild(BuildContext context) {
    if (isLoading) return const CustomLoadingIndicator();
    if (child != null) return child!;

    return Text(
      text!,
      style: CustomTextStyles.of(context)
          .medium24
          .copyWith(color: _getButtonColor(context), height: _textHeight, fontSize: _fontSize),
    );
  }

  double get _width {
    switch (buttonStyle) {
      case CustomButtonStyle.big:
        return 240.0;
      case CustomButtonStyle.small:
        return 160.0;
    }
  }

  double get _height {
    switch (buttonStyle) {
      case CustomButtonStyle.big:
        return 80.0;
      case CustomButtonStyle.small:
        return 50.0;
    }
  }

  Color _backgroundColor(BuildContext context) {
    switch (buttonStyle) {
      case CustomButtonStyle.big:
        return CustomColors.of(context).primary;
      case CustomButtonStyle.small:
        return CustomColors.of(context).secondary;
    }
  }

  double get _fontSize {
    switch (buttonStyle) {
      case CustomButtonStyle.big:
        return 24.0;
      case CustomButtonStyle.small:
        return 20.0;
    }
  }

  double get _textHeight {
    switch (buttonStyle) {
      case CustomButtonStyle.big:
        return 2.0;
      case CustomButtonStyle.small:
        return 1.5;
    }
  }

  Color _splashColor(BuildContext context) {
    switch (buttonStyle) {
      case CustomButtonStyle.big:
        return Colors.white.withOpacity(0.09);
      case CustomButtonStyle.small:
        return CustomColors.of(context).primary.withOpacity(0.09);
    }
  }
}
