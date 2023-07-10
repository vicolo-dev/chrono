import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

RadioThemeData getRadioTheme(ColorScheme colorScheme) {
  return RadioThemeData(
    fillColor: MaterialStateProperty.all(colorScheme.primary),
  );
}
