import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/popup_menu.dart';
import 'package:clock_app/theme/slider.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:flutter/material.dart';

ThemeData getThemeFromColorScheme(
    ThemeData theme, ColorSchemeData colorSchemeData) {
  StyleTheme styleTheme = appSettings
      .getGroup("Appearance")
      .getGroup("Style")
      .getSetting("Style Theme")
      .value;

  return theme.copyWith(
      colorScheme: getColorScheme(colorSchemeData),
      scaffoldBackgroundColor: colorSchemeData.background,
      cardColor: colorSchemeData.card,
      radioTheme: getRadioTheme(colorSchemeData),
      dialogBackgroundColor: colorSchemeData.card,
      bottomSheetTheme: getBottomSheetTheme(colorSchemeData, styleTheme),
      textTheme: theme.textTheme.apply(
        bodyColor: colorSchemeData.onBackground,
        displayColor: colorSchemeData.onBackground,
      ),
      snackBarTheme: getSnackBarTheme(colorSchemeData, styleTheme),
      inputDecorationTheme: getInputTheme(colorSchemeData, styleTheme),
      popupMenuTheme: getPopupMenuTheme(colorSchemeData, styleTheme),
      switchTheme: getSwitchTheme(colorSchemeData),
      sliderTheme: getSliderTheme(colorSchemeData));
}
