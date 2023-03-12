import 'package:clock_app/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer(
      {super.key,
      required this.child,
      this.elevationMultiplier = 1,
      this.color,
      this.margin,
      this.onTap,
      this.alignment});

  final Widget child;
  final double elevationMultiplier;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    ThemeStyle? themeStyle = Theme.of(context).extension<ThemeStyle>();

    return Container(
      alignment: alignment,
      margin: margin ?? const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius:
            (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                .borderRadius,
        boxShadow: [
          BoxShadow(
            color:
                themeStyle?.shadowColor.withOpacity(themeStyle.shadowOpacity) ??
                    Theme.of(context).shadowColor,
            blurRadius: themeStyle?.shadowBlurRadius ?? 5,
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
