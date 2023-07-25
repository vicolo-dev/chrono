import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:flutter/material.dart';

ThemeData getThemeFromColorScheme(
    ThemeData theme, ColorSchemeData colorSchemeData) {
  return theme.copyWith(
    colorScheme: getColorScheme(colorSchemeData),
    scaffoldBackgroundColor: colorSchemeData.background,
    cardColor: colorSchemeData.card,
    radioTheme: getRadioTheme(colorSchemeData),
    dialogBackgroundColor: colorSchemeData.card,
    bottomSheetTheme: getBottomSheetTheme(colorSchemeData,
        theme.toggleButtonsTheme.borderRadius?.bottomLeft ?? Radius.zero),
    textTheme: theme.textTheme.apply(
      bodyColor: colorSchemeData.onBackground,
      displayColor: colorSchemeData.onBackground,
    ),
    snackBarTheme: getSnackBarTheme(
        colorSchemeData, theme.toggleButtonsTheme.borderRadius!),
    inputDecorationTheme:
        getInputTheme(colorSchemeData, theme.toggleButtonsTheme.borderRadius!),
  );
}
