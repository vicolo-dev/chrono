import 'package:clock_app/theme/color_scheme.dart';
import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

InputDecorationTheme getInputTheme(
        ColorSchemeData colorScheme, BorderRadius borderRadius) =>
    InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: colorScheme.onCard.withOpacity(0.12),
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
        borderSide: BorderSide(color: colorScheme.accent, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      hintStyle: textTheme.displaySmall
          ?.copyWith(color: colorScheme.onCard.withOpacity(0.36)),
      errorStyle: const TextStyle(fontSize: 0.0, height: 0.0),
      border: OutlineInputBorder(borderRadius: borderRadius),
    );
