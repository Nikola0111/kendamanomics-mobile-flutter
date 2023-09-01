import 'package:flutter/material.dart';

class CustomColors {
  final BuildContext _context;
  const CustomColors.of(BuildContext context) : _context = context;

  Color get primary => Theme.of(_context).extension<CustomColorScheme>()!.primary!;
  Color get backgroundColor => Theme.of(_context).extension<CustomColorScheme>()!.backgroundColor!;
  Color get errorColor => Theme.of(_context).extension<CustomColorScheme>()!.errorColor!;
  Color get primaryText => Theme.of(_context).extension<CustomColorScheme>()!.primaryText!;
}

@immutable
class CustomColorScheme extends ThemeExtension<CustomColorScheme> {
  final Color? primary;
  final Color? backgroundColor;
  final Color? errorColor;
  final Color? primaryText;

  const CustomColorScheme({
    required this.primary,
    required this.backgroundColor,
    required this.errorColor,
    required this.primaryText,
  });

  const CustomColorScheme.classic({
    this.primary = const Color(0xffca7e44),
    this.backgroundColor = const Color(0xffecddcd),
    this.errorColor = const Color(0xffd70000),
    this.primaryText = const Color(0xff66482e),
  });

  @override
  ThemeExtension<CustomColorScheme> copyWith({
    Color? primary,
    Color? errorColor,
    Color? backgroundColor,
    Color? primaryText,
  }) {
    return CustomColorScheme(
      primary: primary ?? this.primary,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      errorColor: errorColor ?? this.errorColor,
      primaryText: primaryText ?? this.primaryText,
    );
  }

  @override
  ThemeExtension<CustomColorScheme> lerp(ThemeExtension<CustomColorScheme>? other, double t) {
    if (other is! CustomColorScheme) {
      return this;
    }
    return CustomColorScheme(
      primary: Color.lerp(primary, other.primary, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
      primaryText: Color.lerp(primaryText, other.primaryText, t),
    );
  }
}
