import 'package:flutter/material.dart';

class ColorTheme {
  static const MaterialColor primarySwatch = Colors.cyan;

  static const Color accentColor = primarySwatch;
  static const Color backgroundColor = Colors.grey;

  static const Color textColor = Color.fromARGB(255, 46, 53, 68);
  static const Color textColorSecondary = Color.fromARGB(255, 81, 91, 114);
  static const Color textColorTertiary = Color.fromARGB(255, 144, 154, 179);
}

ColorScheme colorScheme =
    ColorScheme.fromSwatch(primarySwatch: ColorTheme.primarySwatch)
        .copyWith(background: ColorTheme.backgroundColor);
