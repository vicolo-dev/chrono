import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

InputDecorationTheme getInputTheme(
        ColorScheme colorScheme, BorderRadius borderRadius) =>
    InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: colorScheme.onSurface.withOpacity(0.12),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      hintStyle: textTheme.displaySmall
          ?.copyWith(color: colorScheme.onSurface.withOpacity(0.36)),
      errorStyle: const TextStyle(fontSize: 0.0, height: 0.0),
      border: OutlineInputBorder(borderRadius: borderRadius),
    );
