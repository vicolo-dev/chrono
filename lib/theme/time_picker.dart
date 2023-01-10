import 'package:clock_app/theme/color.dart';
import 'package:clock_app/theme/shape.dart';
import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

TimePickerThemeData timePickerTheme = TimePickerThemeData(
  hourMinuteShape: defaultShape,
  dayPeriodShape: defaultShape,
  dialBackgroundColor: Colors.grey.shade200,
  helpTextStyle: textTheme.displaySmall?.copyWith(
    color: ColorTheme.textColorSecondary,
  ),
  hourMinuteTextStyle: textTheme.displayMedium,
  dayPeriodTextStyle: textTheme.displaySmall,
  hourMinuteTextColor: ColorTheme.textColorSecondary,
  dialTextColor: ColorTheme.textColorSecondary,
  dayPeriodTextColor: ColorTheme.textColorSecondary,
  shape: defaultShape,
  dayPeriodBorderSide: BorderSide.none,
  entryModeIconColor: ColorTheme.textColorSecondary,
);
