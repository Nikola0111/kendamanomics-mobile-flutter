import 'dart:ui';

extension ColorExtension on Color {
  String formatToString() => toString().split('(0x')[1].split(')')[0];
  static int formatStringForColorConstructor(String colorString) => int.parse(colorString, radix: 16);
}
