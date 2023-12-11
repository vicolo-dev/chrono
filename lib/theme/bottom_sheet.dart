import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:flutter/material.dart';

BottomSheetThemeData getBottomSheetTheme(
        ColorSchemeData colorScheme, StyleTheme styleTheme) =>
    BottomSheetThemeData(
      backgroundColor: colorScheme.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(styleTheme.borderRadius),
        ),
      ),
    );
