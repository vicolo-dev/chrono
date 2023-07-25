import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/theme_extension.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:flutter/material.dart';

ThemeData getThemeFromStyleTheme(ThemeData theme, StyleTheme styleTheme) {
  ColorSchemeData colorSchemeData = appSettings
      .getGroup("Appearance")
      .getGroup("Colors")
      .getSetting("Color Scheme")
      .value;
  RoundedRectangleBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(styleTheme.borderRadius),
  );
  return theme = theme.copyWith(
    cardTheme: theme.cardTheme.copyWith(shape: shape),
    bottomSheetTheme: getBottomSheetTheme(
        colorSchemeData, Radius.circular(styleTheme.borderRadius)),
    timePickerTheme: theme.timePickerTheme.copyWith(
      shape: shape,
      dayPeriodShape: shape,
      hourMinuteShape: shape,
    ),
    toggleButtonsTheme: theme.toggleButtonsTheme.copyWith(
      borderRadius: BorderRadius.circular(styleTheme.borderRadius),
    ),
    snackBarTheme: getSnackBarTheme(
        colorSchemeData, BorderRadius.circular(styleTheme.borderRadius)),
    inputDecorationTheme: getInputTheme(
        colorSchemeData, BorderRadius.circular(styleTheme.borderRadius)),
    extensions: [
      theme.extension<ThemeStyle>()?.copyWith(
                borderRadius: styleTheme.borderRadius,
                shadowElevation: styleTheme.shadowElevation,
                shadowBlurRadius: styleTheme.shadowBlurRadius,
                shadowOpacity: styleTheme.shadowOpacity,
                shadowSpreadRadius: styleTheme.shadowSpreadRadius,
                borderWidth: styleTheme.borderWidth,
              ) ??
          const ThemeStyle(),
    ],
  );
}
