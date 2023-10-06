import 'package:flutter/material.dart';

class CustomTextStyles {
  final BuildContext _context;
  const CustomTextStyles.of(BuildContext context) : _context = context;

  TextStyle get light12 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light12!;
  TextStyle get light16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light16!;
  TextStyle get light20 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light20!;
  TextStyle get light24 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light24!;
  TextStyle get light24Opacity => Theme.of(_context).extension<CustomTextStyleScheme>()!.light24Opacity!;
  TextStyle get regular16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular16!;
  TextStyle get regular25 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular25!;
  TextStyle get medium16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.medium16!;
  TextStyle get medium24 => Theme.of(_context).extension<CustomTextStyleScheme>()!.medium24!;
}

@immutable
class CustomTextStyleScheme extends ThemeExtension<CustomTextStyleScheme> {
  static const _fontFamily = 'GillSans';
  final TextStyle? light12;
  final TextStyle? light16; // in design its 100px ?
  final TextStyle? light20; // in design its 150px
  final TextStyle? light24; // in design its 170px
  final TextStyle? light24Opacity;
  final TextStyle? regular16; //102.68px
  final TextStyle? regular25;
  final TextStyle? medium16;
  final TextStyle? medium24;

  const CustomTextStyleScheme({
    required this.light12,
    required this.light16,
    required this.light20,
    required this.light24,
    required this.light24Opacity,
    required this.regular16,
    required this.regular25,
    required this.medium16,
    required this.medium24,
  });

  factory CustomTextStyleScheme.fromPrimaryTextColor({required Color primaryTextColor}) {
    return CustomTextStyleScheme(
      light12: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 12,
        letterSpacing: 1.1,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w100,
      ),
      light16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        letterSpacing: 1.1,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w100,
      ),
      light20: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 20,
        decoration: TextDecoration.none,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w300,
      ),
      light24: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 24,
        decoration: TextDecoration.none,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w300,
      ),
      light24Opacity: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor.withOpacity(0.5),
        fontSize: 24,
        height: 1.8,
        decoration: TextDecoration.none,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w300,
      ),
      regular16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        letterSpacing: 1.25,
        fontWeight: FontWeight.w400,
      ),
      regular25: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 25,
        decoration: TextDecoration.none,
        letterSpacing: 1.25,
        fontWeight: FontWeight.w400,
      ),
      medium16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w500,
      ),
      medium24: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 24,
        decoration: TextDecoration.none,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  CustomTextStyleScheme copyWith({
    TextStyle? light12,
    TextStyle? light16,
    TextStyle? light20,
    TextStyle? light24,
    TextStyle? light24Opacity,
    TextStyle? regular16,
    TextStyle? regular25,
    TextStyle? medium16,
    TextStyle? medium24,
  }) {
    return CustomTextStyleScheme(
      light12: light12 ?? this.light12,
      light16: light16 ?? this.light16,
      light20: light20 ?? this.light20,
      light24: light24 ?? this.light24,
      light24Opacity: light24Opacity ?? this.light24Opacity,
      regular16: regular16 ?? this.regular16,
      regular25: regular25 ?? this.regular25,
      medium16: medium16 ?? this.medium16,
      medium24: medium24 ?? this.medium24,
    );
  }

  @override
  CustomTextStyleScheme lerp(ThemeExtension<CustomTextStyleScheme>? other, double t) {
    if (other is! CustomTextStyleScheme) {
      return this;
    }
    return CustomTextStyleScheme(
      light12: TextStyle.lerp(light12, other.light12, t),
      light16: TextStyle.lerp(light16, other.light16, t),
      light20: TextStyle.lerp(light20, other.light20, t),
      light24: TextStyle.lerp(light24, other.light24, t),
      light24Opacity: TextStyle.lerp(light24Opacity, other.light24Opacity, t),
      regular16: TextStyle.lerp(regular16, other.regular16, t),
      regular25: TextStyle.lerp(regular25, other.regular25, t),
      medium16: TextStyle.lerp(medium16, other.medium16, t),
      medium24: TextStyle.lerp(medium24, other.medium24, t),
    );
  }
}
