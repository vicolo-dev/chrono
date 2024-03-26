import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/card.dart';
import 'package:clock_app/theme/data/default_style_themes.dart';
import 'package:clock_app/theme/popup_menu.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/data/default_color_schemes.dart';
import 'package:clock_app/theme/dialog.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/slider.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/time_picker.dart';
import 'package:clock_app/theme/toggle_buttons.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/types/theme_extension.dart';
import 'package:flutter/material.dart';

ColorSchemeData defaultColorScheme = defaultColorSchemes[0];
ColorSchemeData defaultDarkColorScheme = defaultColorSchemes[2];
StyleTheme defaultStyleTheme = defaultStyleThemes[0];

ThemeData defaultTheme = ThemeData(
  fontFamily: 'Rubik',
  textTheme: textTheme.apply(
    bodyColor: defaultColorScheme.onBackground,
    displayColor: defaultColorScheme.onBackground,
  ),
  cardTheme: cardTheme,
  colorScheme: getColorScheme(defaultColorScheme),
  timePickerTheme: timePickerTheme,
  dialogTheme: dialogTheme,
  switchTheme: getSwitchTheme(defaultColorScheme),
  snackBarTheme: getSnackBarTheme(defaultColorScheme, defaultStyleTheme),
  inputDecorationTheme: getInputTheme(defaultColorScheme, defaultStyleTheme),
  radioTheme: getRadioTheme(defaultColorScheme),
  sliderTheme: getSliderTheme(defaultColorScheme),
  bottomSheetTheme: getBottomSheetTheme(defaultColorScheme, defaultStyleTheme),
  toggleButtonsTheme: toggleButtonsTheme,
  extensions: const <ThemeExtension<dynamic>>[ThemeStyleExtension()],
  popupMenuTheme: getPopupMenuTheme(defaultColorScheme, defaultStyleTheme),
);
