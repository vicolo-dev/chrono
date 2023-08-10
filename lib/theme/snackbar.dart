import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:flutter/material.dart';

SnackBarThemeData getSnackBarTheme(
        ColorSchemeData colorScheme, StyleTheme styleTheme) =>
    SnackBarThemeData(
      backgroundColor: colorScheme.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(styleTheme.borderRadius),
      ),
      contentTextStyle:
          textTheme.labelSmall?.copyWith(color: colorScheme.onAccent),
    );
