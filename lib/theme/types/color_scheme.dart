import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/theme/data/color_scheme_settings_schema.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:flutter/material.dart';

class ColorSchemeData extends ThemeItem {
  ColorSchemeData({
    String name = "Color Scheme",
    Color background = const Color.fromARGB(255, 248, 250, 250),
    Color onBackground = const Color.fromARGB(255, 46, 53, 68),
    Color card = Colors.white,
    Color onCard = const Color.fromARGB(255, 46, 53, 68),
    Color accent = Colors.cyan,
    Color onAccent = Colors.white,
    bool useAccentAsShadow = false,
    Color shadow = Colors.black,
    bool useAccentAsOutline = false,
    Color outline = const Color.fromARGB(255, 46, 53, 68),
    Color error = Colors.red,
    Color onError = Colors.white,
    bool isDefault = false,
  }) : super(colorSchemeSettingsSchema.copy(), isDefault) {
    settings.getSetting("Name").setValueWithoutNotify(name);
    settings
        .getGroup("Background")
        .getSetting("Color")
        .setValueWithoutNotify(background);
    settings
        .getGroup("Background")
        .getSetting("Text")
        .setValueWithoutNotify(onBackground);
    settings.getGroup("Card").getSetting("Color").setValueWithoutNotify(card);
    settings.getGroup("Card").getSetting("Text").setValueWithoutNotify(onCard);
    settings
        .getGroup("Accent")
        .getSetting("Color")
        .setValueWithoutNotify(accent);
    settings
        .getGroup("Accent")
        .getSetting("Text")
        .setValueWithoutNotify(onAccent);
    settings
        .getGroup("Shadow")
        .getSetting("Use Accent as Shadow")
        .setValueWithoutNotify(useAccentAsShadow);
    settings
        .getGroup("Shadow")
        .getSetting("Color")
        .setValueWithoutNotify(shadow);
    settings
        .getGroup("Outline")
        .getSetting("Use Accent as Outline")
        .setValueWithoutNotify(useAccentAsOutline);
    settings
        .getGroup("Outline")
        .getSetting("Color")
        .setValueWithoutNotify(outline);
    settings.getGroup("Error").getSetting("Color").setValueWithoutNotify(error);
    settings
        .getGroup("Error")
        .getSetting("Text")
        .setValueWithoutNotify(onError);
  }

  ColorSchemeData.from(ColorSchemeData colorSchemeData)
      : super.from(colorSchemeData);

  @override
  String get name => settings.getSetting("Name").value;
  Color get background =>
      settings.getGroup("Background").getSetting("Color").value;
  Color get onBackground =>
      settings.getGroup("Background").getSetting("Text").value;
  Color get card => settings.getGroup("Card").getSetting("Color").value;
  Color get onCard => settings.getGroup("Card").getSetting("Text").value;
  Color get accent => settings.getGroup("Accent").getSetting("Color").value;
  Color get onAccent => settings.getGroup("Accent").getSetting("Text").value;
  bool get useAccentAsShadow =>
      settings.getGroup("Shadow").getSetting("Use Accent as Shadow").value;
  Color get shadow => settings.getGroup("Shadow").getSetting("Color").value;
  bool get useAccentAsOutline =>
      settings.getGroup("Outline").getSetting("Use Accent as Outline").value;
  Color get outline => settings.getGroup("Outline").getSetting("Color").value;
  Color get error => settings.getGroup("Error").getSetting("Color").value;
  Color get onError => settings.getGroup("Error").getSetting("Text").value;

  set accent(Color value) => settings
      .getGroup("Accent")
      .getSetting("Color")
      .setValueWithoutNotify(value);
  set name(String value) =>
      settings.getSetting("Name").setValueWithoutNotify(value);

  @override
  ColorSchemeData copy() {
    ColorSchemeData newColorScheme = ColorSchemeData.from(this);
    newColorScheme.name = "Copy of $name";
    return newColorScheme;
  }

  ColorSchemeData.fromJson(Json json)
      : super.fromJson(json, colorSchemeSettingsSchema.copy());
}

ColorScheme getColorScheme(ColorSchemeData colorSchemeData) {
  return ColorScheme(
    background: colorSchemeData.background,
    error: colorSchemeData.error,
    secondary: colorSchemeData.accent,
    brightness: Brightness.light,
    onError: colorSchemeData.onError,
    onPrimary: colorSchemeData.onAccent,
    surface: colorSchemeData.card,
    primary: colorSchemeData.accent,
    onSurface: colorSchemeData.onBackground,
    onSecondary: colorSchemeData.onAccent,
    onBackground: colorSchemeData.onBackground,
    shadow: colorSchemeData.useAccentAsShadow
        ? colorSchemeData.accent
        : colorSchemeData.shadow,
    outline: colorSchemeData.useAccentAsOutline
        ? colorSchemeData.accent
        : colorSchemeData.outline,
  );
}
