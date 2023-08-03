import 'package:flutter/material.dart';

Size calcTextSize(String text, TextStyle style) {
  // String text = '0' * length;
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
  )..layout();
  return textPainter.size;
}
