import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

InputDecorationTheme inputTheme = InputDecorationTheme(
  contentPadding: EdgeInsets.zero,
  filled: true,
  enabledBorder: const OutlineInputBorder(
    borderRadius: defaultBorderRadius,
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: defaultBorderRadius,
    borderSide: BorderSide(color: colorScheme.error, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: defaultBorderRadius,
    borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: defaultBorderRadius,
    borderSide: BorderSide(color: colorScheme.error, width: 2.0),
  ),
  hintStyle: textTheme.displaySmall
      ?.copyWith(color: colorScheme.onSurface.withOpacity(0.36)),
  errorStyle: const TextStyle(fontSize: 0.0, height: 0.0),
  border: const OutlineInputBorder(borderRadius: defaultBorderRadius),
);
