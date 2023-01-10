import 'package:flutter/material.dart';

import 'package:clock_app/theme/color.dart';

SwitchThemeData switchTheme = SwitchThemeData(
  thumbColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? colorScheme.primary : null),
  trackColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? colorScheme.primary.withOpacity(0.4)
          : null),
);
