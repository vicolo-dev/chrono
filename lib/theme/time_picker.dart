import 'package:clock_app/theme/shape.dart';
import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

TimePickerThemeData timePickerTheme = TimePickerThemeData(
  hourMinuteShape: defaultShape,
  dayPeriodShape: defaultShape,
  // dialBackgroundColor: Colors.grey.shade200,
  helpTextStyle: textTheme.displaySmall?.copyWith(
      // color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
      ),
  hourMinuteTextStyle: textTheme.displayMedium,
  dayPeriodTextStyle: textTheme.displaySmall,
  // hourMinuteTextColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
  // dialTextColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
  // dayPeriodTextColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
  shape: defaultShape,
  dayPeriodBorderSide: BorderSide.none,
  // entryModeIconColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
);
