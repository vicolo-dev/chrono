import 'package:flutter/material.dart';

import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/card.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/dialog.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/time_picker.dart';

ThemeData theme = ThemeData(
  fontFamily: 'Rubik',
  textTheme: textTheme,
  cardTheme: cardTheme,
  colorScheme: colorScheme,
  timePickerTheme: timePickerTheme,
  dialogTheme: dialogTheme,
  switchTheme: switchTheme,
  snackBarTheme: snackBarTheme,
  inputDecorationTheme: inputTheme,
  scaffoldBackgroundColor: ColorTheme.backgroundColor,
  // textButtonTheme: textButtonTheme,
);
