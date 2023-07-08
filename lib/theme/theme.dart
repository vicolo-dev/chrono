import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/card.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/theme/dialog.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/slider.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/theme_extension.dart';
import 'package:clock_app/theme/time_picker.dart';
import 'package:clock_app/theme/toggle_buttons.dart';
import 'package:flutter/material.dart';

ThemeData defaultTheme = ThemeData(
  fontFamily: 'Rubik',
  // canvasColor: Colors.transparent,
  textTheme: textTheme.apply(
    bodyColor: lightColorScheme.onBackground,
    displayColor: lightColorScheme.onBackground,
  ),

  cardTheme: cardTheme,
  colorScheme: lightColorScheme,
  timePickerTheme: timePickerTheme,
  dialogTheme: dialogTheme,
  switchTheme: switchTheme,
  snackBarTheme: getSnackBarTheme(lightColorScheme, defaultBorderRadius),
  inputDecorationTheme: getInputTheme(lightColorScheme, defaultBorderRadius),
  radioTheme: radioTheme,
  sliderTheme: sliderTheme,
  bottomSheetTheme:
      getBottomSheetTheme(lightColorScheme, defaultBorderRadius.topLeft),
  toggleButtonsTheme: toggleButtonsTheme,
  // progressIndicatorTheme: ProgressIndicatorThemeData(

  // ),
  extensions: const <ThemeExtension<dynamic>>[ThemeStyle()],

  // textButtonTheme: textButtonTheme,
);

// ThemeData theme2 = ThemeData(
//   fontFamily: 'Rubik',
//   // canvasColor: Colors.transparent,
//   textTheme: textTheme,
//   cardTheme: cardTheme,
//   colorScheme: colorScheme,
//   timePickerTheme: timePickerTheme,
//   dialogTheme: dialogTheme,
//   switchTheme: switchTheme,
//   snackBarTheme: snackBarTheme,
//   inputDecorationTheme: inputTheme,
//   scaffoldBackgroundColor: ColorTheme.backgroundColor,
//   radioTheme: radioTheme,
//   sliderTheme: sliderTheme,
//   // textButtonTheme: textButtonTheme,
// );
