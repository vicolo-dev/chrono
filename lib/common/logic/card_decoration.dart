import 'package:clock_app/theme/types/theme_extension.dart';
import 'package:flutter/material.dart';

BoxDecoration getCardDecoration(BuildContext context,
    {Color? color,
    bool showLightBorder = false,
    showShadow = true,
    elevationMultiplier = 1,
    blurStyle = BlurStyle.normal}) {
  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;
  ThemeStyleExtension? themeStyle = theme.extension<ThemeStyleExtension>();

  return BoxDecoration(
    border: showLightBorder
        ? Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignInside,
          )
        : (themeStyle?.borderWidth != 0)
            ? Border.all(
                color: colorScheme.outline,
                width: themeStyle?.borderWidth ?? 0.5,
                strokeAlign: BorderSide.strokeAlignInside,
              )
            : null,
    color: color ?? Theme.of(context).colorScheme.surface,
    borderRadius: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
        .borderRadius,
    boxShadow: [
      if (showShadow && (themeStyle?.shadowOpacity ?? 0) > 0)
        BoxShadow(
          blurStyle: blurStyle,
          color: colorScheme.shadow.withOpacity(themeStyle?.shadowOpacity ?? 1),
          blurRadius: themeStyle?.shadowBlurRadius ?? 5,
          spreadRadius: themeStyle?.shadowSpreadRadius ?? 0,
          offset: Offset(
              0, (themeStyle?.shadowElevation ?? 1) * elevationMultiplier),
        ),
    ],
  );
}
