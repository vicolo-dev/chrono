import 'package:flutter/material.dart';

BottomSheetThemeData getBottomSheetTheme(Radius borderRadius) =>
    BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: borderRadius,
        ),
      ),
    );
