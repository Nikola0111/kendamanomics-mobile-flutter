import 'package:flutter/material.dart';

extension StringExtension on String {
  Size calculateSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: this, style: style), textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  double calculateConstrainedFontSize({
    required BuildContext context,
    required TextStyle textStyle,
    required double maxWidth,
    required double maxHeight,
    required double minFontSize,
  }) {
    double fontSize = textStyle.fontSize!;
    while (true) {
      final newStyle = textStyle.copyWith(fontSize: fontSize);
      final painter = TextPainter(
        text: TextSpan(text: this, style: newStyle),
        textScaleFactor: MediaQuery.textScaleFactorOf(context),
        textDirection: TextDirection.ltr,
      )..layout(
          minWidth: 0.0,
          maxWidth: maxWidth,
        );
      if (painter.size.height <= maxHeight || fontSize <= minFontSize) {
        return fontSize;
      }
      fontSize -= 0.5;
    }
  }

  int getNumberOfLines({required TextStyle style, required double maxWidth}) {
    final span = TextSpan(text: this, style: style);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: maxWidth);
    return tp.computeLineMetrics().length;
  }
}
