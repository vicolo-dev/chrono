import 'package:clock_app/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.child,
    this.elevationMultiplier = 1,
    this.color,
    this.margin,
    this.onTap,
    this.alignment,
    this.showShadow = true,
    this.showLightBorder = false,
    this.blurStyle = BlurStyle.normal,
  });

  final Widget child;
  final double elevationMultiplier;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Alignment? alignment;
  final bool showShadow;
  final BlurStyle blurStyle;
  final bool showLightBorder;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    ThemeStyle? themeStyle = theme.extension<ThemeStyle>();

    return Container(
      alignment: alignment,
      margin: margin ?? const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
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
        borderRadius:
            (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                .borderRadius,
        boxShadow: [
          if (showShadow && (themeStyle?.shadowOpacity ?? 0) > 0)
            BoxShadow(
              blurStyle: blurStyle,
              color: colorScheme.shadow
                  .withOpacity(themeStyle?.shadowOpacity ?? 1),
              blurRadius: themeStyle?.shadowBlurRadius ?? 5,
              spreadRadius: themeStyle?.shadowSpreadRadius ?? 0,
              offset: Offset(
                  0, (themeStyle?.shadowElevation ?? 1) * elevationMultiplier),
            ),
        ],
      ),
      child: onTap == null
          ? child
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: Theme.of(context).toggleButtonsTheme.borderRadius,
                child: child,
              ),
            ),
    );
  }
}
