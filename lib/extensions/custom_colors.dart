import 'package:flutter/material.dart';

class CustomColors {
  final BuildContext _context;
  const CustomColors.of(BuildContext context) : _context = context;

  Color get primary => Theme.of(_context).extension<CustomColorScheme>()!.primary!;
  Color get secondary => Theme.of(_context).extension<CustomColorScheme>()!.secondary!;
  Color get backgroundColor => Theme.of(_context).extension<CustomColorScheme>()!.backgroundColor!;
  Color get errorColor => Theme.of(_context).extension<CustomColorScheme>()!.errorColor!;
  Color get deniedColor => Theme.of(_context).extension<CustomColorScheme>()!.deniedColor!;
  Color get lacedColor => Theme.of(_context).extension<CustomColorScheme>()!.lacedColor!;
  Color get primaryText => Theme.of(_context).extension<CustomColorScheme>()!.primaryText!;
  Color get borderColor => Theme.of(_context).extension<CustomColorScheme>()!.borderColor!;
  Color get activeIndicatorColor => Theme.of(_context).extension<CustomColorScheme>()!.activeIndicatorColor!;
  Color get timelineColor => Theme.of(_context).extension<CustomColorScheme>()!.timelineColor!;
  Color get logLabel => Theme.of(_context).extension<CustomColorScheme>()!.logLabel!;
  Color get logBorder => Theme.of(_context).extension<CustomColorScheme>()!.logBorder!;
}

@immutable
class CustomColorScheme extends ThemeExtension<CustomColorScheme> {
  final Color? primary;
  final Color? secondary;
  final Color? backgroundColor;
  final Color? errorColor;
  final Color? deniedColor;
  final Color? lacedColor;
  final Color? primaryText;
  final Color? borderColor;
  final Color? activeIndicatorColor;
  final Color? timelineColor;
  final Color? logLabel;
  final Color? logBorder;

  const CustomColorScheme({
    required this.primary,
    required this.secondary,
    required this.backgroundColor,
    required this.errorColor,
    required this.deniedColor,
    required this.lacedColor,
    required this.primaryText,
    required this.borderColor,
    required this.activeIndicatorColor,
    required this.timelineColor,
    required this.logLabel,
    required this.logBorder,
  });

  const CustomColorScheme.classic({
    this.primary = const Color(0xffca7e44),
    this.secondary = const Color(0xfff0d6c3),
    this.backgroundColor = const Color(0xffecddcd),
    this.errorColor = const Color(0xffd70000),
    this.deniedColor = const Color(0xff961C1C),
    this.lacedColor = const Color(0xff4D683D),
    this.primaryText = const Color(0xff66482e),
    this.borderColor = const Color(0xff6D3036),
    this.activeIndicatorColor = const Color(0xffD3B28F),
    this.timelineColor = const Color(0xff854b23),
    this.logLabel = const Color(0xffFAE2B2),
    this.logBorder = const Color(0xffd9bc95),
  });

  @override
  ThemeExtension<CustomColorScheme> copyWith({
    Color? primary,
    Color? secondary,
    Color? errorColor,
    Color? deniedColor,
    Color? lacedColor,
    Color? backgroundColor,
    Color? primaryText,
    Color? borderColor,
    Color? activeIndicatorColor,
    Color? timelineColor,
    Color? logLabel,
    Color? logBorder,
  }) {
    return CustomColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      errorColor: errorColor ?? this.errorColor,
      deniedColor: deniedColor ?? this.deniedColor,
      lacedColor: lacedColor ?? this.lacedColor,
      primaryText: primaryText ?? this.primaryText,
      borderColor: borderColor ?? this.borderColor,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      timelineColor: timelineColor ?? this.timelineColor,
      logLabel: logLabel ?? this.logLabel,
      logBorder: logBorder ?? this.logBorder,
    );
  }

  @override
  ThemeExtension<CustomColorScheme> lerp(ThemeExtension<CustomColorScheme>? other, double t) {
    if (other is! CustomColorScheme) {
      return this;
    }
    return CustomColorScheme(
      primary: Color.lerp(primary, other.primary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
      deniedColor: Color.lerp(deniedColor, other.deniedColor, t),
      lacedColor: Color.lerp(lacedColor, other.lacedColor, t),
      primaryText: Color.lerp(primaryText, other.primaryText, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      activeIndicatorColor: Color.lerp(activeIndicatorColor, other.activeIndicatorColor, t),
      timelineColor: Color.lerp(timelineColor, other.timelineColor, t),
      logLabel: Color.lerp(logLabel, other.logLabel, t),
      logBorder: Color.lerp(logBorder, other.logBorder, t),
    );
  }
}
