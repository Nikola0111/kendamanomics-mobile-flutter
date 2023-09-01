import 'package:flutter/material.dart';

class CustomTextStyles {
  final BuildContext _context;
  const CustomTextStyles.of(BuildContext context) : _context = context;

  TextStyle get light16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.light16!;
}

@immutable
class CustomTextStyleScheme extends ThemeExtension<CustomTextStyleScheme> {
  static const _fontFamily = 'GillSans';
  final TextStyle? light16;

  const CustomTextStyleScheme({
    required this.light16,
  });

  factory CustomTextStyleScheme.fromPrimaryTextColor({required Color primaryTextColor}) {
    return CustomTextStyleScheme(
      light16: TextStyle(
        fontFamily: _fontFamily,
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        letterSpacing: 2,
      ),
    );
  }

  @override
  CustomTextStyleScheme copyWith({
    TextStyle? medium16,
  }) {
    return CustomTextStyleScheme(
      light16: medium16 ?? this.light16,
    );
  }

  @override
  CustomTextStyleScheme lerp(ThemeExtension<CustomTextStyleScheme>? other, double t) {
    if (other is! CustomTextStyleScheme) {
      return this;
    }
    return CustomTextStyleScheme(
      light16: TextStyle.lerp(light16, other.light16, t),
    );
  }
}
