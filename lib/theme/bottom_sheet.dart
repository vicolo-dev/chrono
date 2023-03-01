import 'package:flutter/material.dart';

BottomSheetThemeData getBottomSheetTheme(
        ColorScheme colorScheme, Radius borderRadius) =>
    BottomSheetThemeData(
      backgroundColor: colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: borderRadius,
        ),
      ),
    );
