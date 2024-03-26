import 'package:clock_app/common/logic/card_decoration.dart';
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

   // TonalPalette primaryTonalP = toTonalPalette(_primaryColor); 
   //  primaryTonalP.get(50); // Getting the specific color
   //
   //
   //  TonalPalette toTonalPalette(int value) {
   //    final color = Hct.fromInt(value);
   //    return TonalPalette.of(color.hue, color.chroma);
   //  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =  theme.colorScheme;
    return  
    // Card.filled(
    //   elevation: 1,
    //   // margin: margin ?? const EdgeInsets.all(4),
    //   // clipBehavior: Clip.hardEdge,
    //   // shape: RoundedRectangleBorder(
    //   // borderRadius: BorderRadius.circular(16),
    //   // side: showLightBorder
    //   //     ? BorderSide(
    //   //         color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
    //   //         width: 1,
    //   //       )
    //   //     : BorderSide.none,
    //   // ),
    //   color: color,
    //   child: InkWell(
    //     onTap: onTap,
    //     child: child,
    //   ),
    //       
    // );
    Container(
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
