import 'package:flutter/material.dart';

class CustomTextStyles {
  final BuildContext _context;
  const CustomTextStyles.of(BuildContext context) : _context = context;

  TextStyle get light12 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light12!;
  TextStyle get light13 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light13!;
  TextStyle get light14 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light14!;
  TextStyle get light15 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light15!;
  TextStyle get light16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light16!;
  TextStyle get light17 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light17!;
  TextStyle get light20 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light20!;
  TextStyle get light24 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light24!;
  TextStyle get light24Opacity => Theme.of(_context).extension<CustomTextStyleScheme>()!.light24Opacity!;
  TextStyle get regular14 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular14!;
  TextStyle get regular16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular16!;
  TextStyle get regular18 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular18!;
  TextStyle get regular20 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular20!;
  TextStyle get regular25 => Theme.of(_context).extension<CustomTextStyleScheme>()!.regular25!;
  TextStyle get medium16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.medium16!;
  TextStyle get medium24 => Theme.of(_context).extension<CustomTextStyleScheme>()!.medium24!;
}

@immutable
class CustomTextStyleScheme extends ThemeExtension<CustomTextStyleScheme> {
  static const _fontFamily = 'GillSans';
  final TextStyle? light12;
  final TextStyle? light13;
  final TextStyle? light14;
  final TextStyle? light15;
  final TextStyle? light16; // in design its 100px ?
  final TextStyle? light17;
  final TextStyle? light20; // in design its 150px
  final TextStyle? light24; // in design its 170px
  final TextStyle? light24Opacity;
  final TextStyle? regular14;
  final TextStyle? regular16; //102.68px
  final TextStyle? regular18;
  final TextStyle? regular20;
  final TextStyle? regular25;
  final TextStyle? medium16;
  final TextStyle? medium24;

  const CustomTextStyleScheme({
    required this.light12,
    required this.light13,
    required this.light14,
    required this.light15,
    required this.light16,
    required this.light17,
    required this.light20,
    required this.light24,
    required this.light24Opacity,
    required this.regular14,
    required this.regular16,
    required this.regular18,
    required this.regular20,
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
        fontWeight: FontWeight.w300,
      ),
      light13: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 13,
        letterSpacing: 0.3,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w300,
      ),
      light14: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 14,
        letterSpacing: 0.3,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w300,
      ),
      light15: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 15,
        letterSpacing: 0.3,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w300,
      ),
      light16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        letterSpacing: 1.1,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w300,
      ),
      light17: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 17,
        letterSpacing: 0.3,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w300,
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
      regular14: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 14,
        decoration: TextDecoration.none,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      ),
      regular16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        letterSpacing: 1.25,
        fontWeight: FontWeight.w400,
      ),
      regular18: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 18,
        decoration: TextDecoration.none,
        letterSpacing: 1.25,
        fontWeight: FontWeight.w400,
      ),
      regular20: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 20,
        decoration: TextDecoration.none,
        letterSpacing: 0.5,
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
    TextStyle? light13,
    TextStyle? light14,
    TextStyle? light15,
    TextStyle? light16,
    TextStyle? light17,
    TextStyle? light20,
    TextStyle? light24,
    TextStyle? light24Opacity,
    TextStyle? regular14,
    TextStyle? regular16,
    TextStyle? regular18,
    TextStyle? regular20,
    TextStyle? regular25,
    TextStyle? medium16,
    TextStyle? medium24,
  }) {
    return CustomTextStyleScheme(
      light12: light12 ?? this.light12,
      light13: light13 ?? this.light13,
      light14: light12 ?? this.light14,
      light15: light15 ?? this.light15,
      light16: light16 ?? this.light16,
      light17: light17 ?? this.light17,
      light20: light20 ?? this.light20,
      light24: light24 ?? this.light24,
      light24Opacity: light24Opacity ?? this.light24Opacity,
      regular14: regular14 ?? this.regular14,
      regular16: regular16 ?? this.regular16,
      regular18: regular18 ?? this.regular18,
      regular20: regular20 ?? this.regular20,
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
      light13: TextStyle.lerp(light13, other.light13, t),
      light14: TextStyle.lerp(light14, other.light14, t),
      light15: TextStyle.lerp(light15, other.light15, t),
      light16: TextStyle.lerp(light16, other.light16, t),
      light17: TextStyle.lerp(light17, other.light17, t),
      light20: TextStyle.lerp(light20, other.light20, t),
      light24: TextStyle.lerp(light24, other.light24, t),
      light24Opacity: TextStyle.lerp(light24Opacity, other.light24Opacity, t),
      regular14: TextStyle.lerp(regular14, other.regular14, t),
      regular16: TextStyle.lerp(regular16, other.regular16, t),
      regular18: TextStyle.lerp(regular18, other.regular18, t),
      regular20: TextStyle.lerp(regular20, other.regular20, t),
      regular25: TextStyle.lerp(regular25, other.regular25, t),
      medium16: TextStyle.lerp(medium16, other.medium16, t),
      medium24: TextStyle.lerp(medium24, other.medium24, t),
    );
  }
}
