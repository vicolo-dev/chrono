import 'package:clock_app/theme/shadow.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer(
      {super.key,
      required this.child,
      this.elevationMultiplier = 1,
      this.color,
      this.margin,
      this.onTap});

  final Widget child;
  final double elevationMultiplier;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    ShadowStyle? shadowStyle = Theme.of(context).extension<ShadowStyle>();

    return Container(
      margin: margin ?? const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius:
            (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                .borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowStyle?.color.withOpacity(shadowStyle.opacity) ??
                Theme.of(context).shadowColor,
            blurRadius: shadowStyle?.blurRadius ?? 5,
            offset:
                Offset(0, (shadowStyle?.elevation ?? 1) * elevationMultiplier),
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
