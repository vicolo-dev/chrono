import 'package:clock_app/theme/color_scheme.dart';
import 'package:flutter/material.dart';

RadioThemeData getRadioTheme(ColorSchemeData colorScheme) {
  return RadioThemeData(
    fillColor: MaterialStateProperty.all(colorScheme.accent),
  );
}
