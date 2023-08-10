import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:flutter/material.dart';

PopupMenuThemeData getPopupMenuTheme(
    ColorSchemeData colorScheme, StyleTheme styleTheme) {
  return PopupMenuThemeData(
    color: colorScheme.background,
    textStyle:
        textTheme.headlineMedium?.copyWith(color: colorScheme.onBackground),
    elevation: styleTheme.shadowElevation * 2,
    shadowColor: colorScheme.shadow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(styleTheme.borderRadius),
    ),
  );
}
