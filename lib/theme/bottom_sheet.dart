import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:flutter/material.dart';

BottomSheetThemeData getBottomSheetTheme(
        ColorSchemeData colorScheme, Radius borderRadius) =>
    BottomSheetThemeData(
      backgroundColor: colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: borderRadius,
        ),
      ),
    );
