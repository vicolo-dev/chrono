import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

SnackBarThemeData getSnackBarTheme(
        ColorScheme colorScheme, BorderRadius borderRadius) =>
    SnackBarThemeData(
      backgroundColor: colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      contentTextStyle:
          textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
    );
