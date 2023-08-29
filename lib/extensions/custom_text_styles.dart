import 'package:flutter/material.dart';

class CustomTextStyles {
  final BuildContext _context;
  const CustomTextStyles.of(BuildContext context) : _context = context;

  TextStyle get medium16 => Theme.of(_context).extension<CustomTextStyleScheme>()!.medium16!;
}

@immutable
class CustomTextStyleScheme extends ThemeExtension<CustomTextStyleScheme> {
  final TextStyle? medium16;

  const CustomTextStyleScheme({
    required this.medium16,
  });

  factory CustomTextStyleScheme.fromPrimaryTextColor({required Color primaryTextColor}) {
    return CustomTextStyleScheme(
      medium16: TextStyle(
        color: primaryTextColor,
        fontSize: 16,
        decoration: TextDecoration.none,
        height: 1.25,
      ),
    );
  }

  @override
  CustomTextStyleScheme copyWith({
    TextStyle? medium16,
  }) {
    return CustomTextStyleScheme(
      medium16: medium16 ?? this.medium16,
    );
  }

  @override
  CustomTextStyleScheme lerp(ThemeExtension<CustomTextStyleScheme>? other, double t) {
    if (other is! CustomTextStyleScheme) {
      return this;
    }
    return CustomTextStyleScheme(
      medium16: TextStyle.lerp(medium16, other.medium16, t),
    );
  }
}
