import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/popup_menu.dart';
import 'package:clock_app/theme/slider.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/types/theme_extension.dart';
import 'package:flutter/material.dart';

ColorSchemeData getColorSchemeData(ColorScheme colorScheme) {
  return ColorSchemeData(
    background: colorScheme.background,
    onBackground: colorScheme.onBackground,
    card: colorScheme.surface,
    onCard: colorScheme.onSurface,
    accent: colorScheme.primary,
    onAccent: colorScheme.onPrimary,
    error: colorScheme.error,
    onError: colorScheme.onError,
  );
}

// ThemeData getThemeFromColorScheme(ThemeData theme, ColorScheme colorScheme) {
//
//   ColorSchemeData colorSchemeData = getColorSchemeData(colorScheme);
//
//   return getThemeFromColorSchemeData(theme, colorSchemeData);
//
//
// }
//
ThemeData getTheme(
    {ColorScheme? colorScheme,
    ColorSchemeData? colorSchemeData,
    StyleTheme? styleTheme}) {
  styleTheme ??= appSettings
      .getGroup("Appearance")
      .getGroup("Style")
      .getSetting("Style Theme")
      .value;

  colorSchemeData ??= colorScheme != null
      ? getColorSchemeData(colorScheme)
      : appSettings
          .getGroup("Appearance")
          .getGroup("Colors")
          .getSetting("Color Scheme")
          .value;

  if (styleTheme == null || colorSchemeData == null) {
    return defaultTheme;
  }
  RoundedRectangleBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(styleTheme.borderRadius),
  );

  return defaultTheme.copyWith(
    colorScheme: colorScheme ?? getColorScheme(colorSchemeData),
    scaffoldBackgroundColor: colorSchemeData.background,
    cardColor: colorSchemeData.card,
    radioTheme: getRadioTheme(colorSchemeData),
    dialogBackgroundColor: colorSchemeData.card,
    bottomSheetTheme: getBottomSheetTheme(colorSchemeData, styleTheme),
    textTheme: defaultTheme.textTheme.apply(
      bodyColor: colorSchemeData.onBackground,
      displayColor: colorSchemeData.onBackground,
    ),
    snackBarTheme: getSnackBarTheme(colorSchemeData, styleTheme),
    inputDecorationTheme: getInputTheme(colorSchemeData, styleTheme),
    popupMenuTheme: getPopupMenuTheme(colorSchemeData, styleTheme),
    switchTheme: getSwitchTheme(colorSchemeData),
    sliderTheme: getSliderTheme(colorSchemeData),
    cardTheme: defaultTheme.cardTheme.copyWith(shape: shape),
    timePickerTheme: defaultTheme.timePickerTheme.copyWith(
      shape: shape,
      dayPeriodShape: shape,
      hourMinuteShape: shape,
    ),
    toggleButtonsTheme: defaultTheme.toggleButtonsTheme.copyWith(
      borderRadius: BorderRadius.circular(styleTheme.borderRadius),
    ),
    extensions: [
      defaultTheme.extension<ThemeStyleExtension>()?.copyWith(
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
