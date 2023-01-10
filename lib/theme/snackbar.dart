import 'package:clock_app/theme/shape.dart';
import 'package:clock_app/theme/text.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/theme/color.dart';

SnackBarThemeData snackBarTheme = SnackBarThemeData(
  backgroundColor: colorScheme.primary,
  behavior: SnackBarBehavior.floating,
  shape: defaultShape,
  contentTextStyle: textTheme.labelSmall?.copyWith(color: Colors.white),
);
