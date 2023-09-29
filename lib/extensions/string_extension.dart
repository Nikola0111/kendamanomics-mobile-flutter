import 'package:flutter/material.dart';

extension StringExtension on String {
  Size calculateSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: this, style: style), textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  int getNumberOfLines({required TextStyle style, required double maxWidth}) {
    final span = TextSpan(text: this, style: style);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: maxWidth);
    return tp.computeLineMetrics().length;
  }
}
