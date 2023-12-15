import 'package:clock_app/common/logic/card_decoration.dart';
import 'package:clock_app/theme/types/theme_extension.dart';
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
    return Container(
      alignment: alignment,
      margin: margin ?? const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: getCardDecoration(
        context,
        color: color,
        showLightBorder: showLightBorder,
        showShadow: showShadow,
        elevationMultiplier: elevationMultiplier,
        blurStyle: blurStyle,
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
