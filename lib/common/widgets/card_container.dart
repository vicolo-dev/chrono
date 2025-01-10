import 'package:clock_app/common/logic/card_decoration.dart';
import 'package:clock_app/theme/types/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/common/utils/color.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';

TonalPalette toTonalPalette(int value) {
  final color = Hct.fromInt(value);
  return TonalPalette.of(color.hue, color.chroma);
}

Color getCardColor(BuildContext context, [Color? color]) {
  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;
  ThemeSettingExtension? themeStyle = theme.extension<ThemeSettingExtension>();

  TonalPalette tonalPalette = toTonalPalette(colorScheme.surface.value);

  return color ??
      (themeStyle != null && themeStyle.useMaterialYou
          ? Color(tonalPalette
              .get(Theme.of(context).brightness == Brightness.light ? 96 : 15))
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
    this.isSelected = false,
    this.showLightBorder = false,
    this.blurStyle = BlurStyle.normal,
    this.onLongPress,
  });

  final Widget child;
  final double elevationMultiplier;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Alignment? alignment;
  final bool showShadow;
  final BlurStyle blurStyle;
  final bool showLightBorder;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Color cardColor = getCardColor(context, color);
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    return Container(
      // duration: const Duration(milliseconds: 100),
      alignment: alignment,
      margin: margin ?? const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: getCardDecoration(
        context,
        color: cardColor,
        isSelected: isSelected,
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
                onLongPress: onLongPress,
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
