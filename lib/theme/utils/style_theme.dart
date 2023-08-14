import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/popup_menu.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/types/theme_extension.dart';
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
    bottomSheetTheme: getBottomSheetTheme(colorSchemeData, styleTheme),
    timePickerTheme: theme.timePickerTheme.copyWith(
      shape: shape,
      dayPeriodShape: shape,
      hourMinuteShape: shape,
    ),
    toggleButtonsTheme: theme.toggleButtonsTheme.copyWith(
      borderRadius: BorderRadius.circular(styleTheme.borderRadius),
    ),
    snackBarTheme: getSnackBarTheme(colorSchemeData, styleTheme),
    inputDecorationTheme: getInputTheme(colorSchemeData, styleTheme),
    popupMenuTheme: getPopupMenuTheme(colorSchemeData, styleTheme),
    extensions: [
      theme.extension<ThemeStyleExtension>()?.copyWith(
                borderRadius: styleTheme.borderRadius,
                shadowElevation: styleTheme.shadowElevation,
                shadowBlurRadius: styleTheme.shadowBlurRadius,
                shadowOpacity: styleTheme.shadowOpacity,
                shadowSpreadRadius: styleTheme.shadowSpreadRadius,
                borderWidth: styleTheme.borderWidth,
              ) ??
          const ThemeStyleExtension(),
    ],
  );
}
