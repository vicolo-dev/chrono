import 'package:clock_app/common/logic/card_decoration.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/common/utils/color.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';


TonalPalette toTonalPalette(int value) {
  final color = Hct.fromInt(value);
  return TonalPalette.of(color.hue, color.chroma);
}

Color getCardColor(BuildContext context, [Color? color]){
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  bool useMaterialYou = appSettings
      .getGroup("Appearance")
      .getGroup("Colors")
      .getSetting("Use Material You")
      .value;

  TonalPalette tonalPalette = toTonalPalette(colorScheme.surface.value);

  return color ??
        (useMaterialYou
            ? Color(tonalPalette.get(
                Theme.of(context).brightness == Brightness.light ? 96 : 15))
            : colorScheme.surface);
}

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
    Color cardColor = getCardColor(context, color);
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    return Container(
      alignment: alignment,
      margin: margin ?? const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: getCardDecoration(
        context,
        color: cardColor,
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
                splashColor: cardColor.darken(0.075),
                borderRadius: Theme.of(context).toggleButtonsTheme.borderRadius,
                child: child,
              ),
            ),
    );
  }
}

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}
