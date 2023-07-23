import 'package:clock_app/theme/color_scheme.dart';
import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

SnackBarThemeData getSnackBarTheme(
        ColorSchemeData colorScheme, BorderRadius borderRadius) =>
    SnackBarThemeData(
      backgroundColor: colorScheme.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      contentTextStyle:
          textTheme.labelSmall?.copyWith(color: colorScheme.onAccent),
    );
