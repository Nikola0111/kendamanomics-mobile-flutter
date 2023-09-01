import 'package:flutter/material.dart';

class CustomTextStyles {
  final BuildContext _context;
  const CustomTextStyles.of(BuildContext context) : _context = context;

  TextStyle get light10 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light10!;
  TextStyle get light16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light16!;
  TextStyle get medium16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.medium16!;
}

@immutable
class CustomTextStyleScheme extends ThemeExtension<CustomTextStyleScheme> {
  static const _fontFamily = 'GillSans';
  final TextStyle? light10;
  final TextStyle? light16;
  final TextStyle? medium16;

  const CustomTextStyleScheme({
    required this.light10,
    required this.light16,
    required this.medium16,
  });

  factory CustomTextStyleScheme.fromPrimaryTextColor({required Color primaryTextColor}) {
    return CustomTextStyleScheme(
      light10: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 10,
        decoration: TextDecoration.none,
        letterSpacing: 1.7,
        fontWeight: FontWeight.w100,
      ),
      light16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        letterSpacing: 1.7,
        fontWeight: FontWeight.w100,
      ),
      medium16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        letterSpacing: 1.7,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  CustomTextStyleScheme copyWith({
    TextStyle? light10,
    TextStyle? light16,
    TextStyle? medium16,
  }) {
    return CustomTextStyleScheme(
      light10: light10 ?? this.light10,
      light16: light16 ?? this.light16,
      medium16: medium16 ?? this.medium16,
    );
  }

  @override
  CustomTextStyleScheme lerp(ThemeExtension<CustomTextStyleScheme>? other, double t) {
    if (other is! CustomTextStyleScheme) {
      return this;
    }
    return CustomTextStyleScheme(
      light10: TextStyle.lerp(light10, other.light10, t),
      light16: TextStyle.lerp(light16, other.light16, t),
      medium16: TextStyle.lerp(medium16, other.medium16, t),
    );
  }
}
