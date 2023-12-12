import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:flutter/material.dart';

SwitchThemeData getSwitchTheme(ColorSchemeData colorScheme) {
  return SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.white : Colors.white),
    trackColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? colorScheme.accent
            : colorScheme.onBackground.withOpacity(0.3)),
    overlayColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? colorScheme.accent
            : colorScheme.onBackground.withOpacity(0.3)),
    trackOutlineColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? colorScheme.accent
            : Colors.transparent),
    splashRadius: 0,
  );
}
