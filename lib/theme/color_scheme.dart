import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/theme/data/color_scheme_settings_schema.dart';
import 'package:flutter/material.dart';

class ColorSchemeData extends ListItem {
  final int _id;
  final SettingGroup _settings;
  final bool _isDefault;

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
  })  : _settings = colorSchemeSettingsSchema.copy(),
        _isDefault = isDefault,
        _id = UniqueKey().hashCode {
    _settings.getSetting("Name").setValueWithoutNotify(name);
    _settings.getSetting("Background").setValueWithoutNotify(background);
    _settings.getSetting("On Background").setValueWithoutNotify(onBackground);
    _settings.getSetting("Card").setValueWithoutNotify(card);
    _settings.getSetting("On Card").setValueWithoutNotify(onCard);
    _settings.getSetting("Accent").setValueWithoutNotify(accent);
    _settings.getSetting("On Accent").setValueWithoutNotify(onAccent);
    _settings
        .getSetting("Use Accent as Shadow")
        .setValueWithoutNotify(useAccentAsShadow);
    _settings.getSetting("Shadow").setValueWithoutNotify(shadow);
    _settings.getSetting("Outline").setValueWithoutNotify(outline);
    _settings.getSetting("Error").setValueWithoutNotify(error);
    _settings.getSetting("On Error").setValueWithoutNotify(onError);
  }

  ColorSchemeData.from(ColorSchemeData colorSchemeData)
      : _id = UniqueKey().hashCode,
        _isDefault = false,
        _settings = colorSchemeData.settings.copy();

  @override
  int get id => _id;
  SettingGroup get settings => _settings;
  bool get isDefault => _isDefault;
  String get name => _settings.getSetting("Name").value;
  Color get background => _settings.getSetting("Background").value;
  Color get onBackground => _settings.getSetting("On Background").value;
  Color get card => _settings.getSetting("Card").value;
  Color get onCard => _settings.getSetting("On Card").value;
  Color get accent => _settings.getSetting("Accent").value;
  Color get onAccent => _settings.getSetting("On Accent").value;
  bool get useAccentAsShadow =>
      _settings.getSetting("Use Accent as Shadow").value;
  Color get shadow => _settings.getSetting("Shadow").value;
  bool get useAccentAsOutline =>
      _settings.getSetting("Use Accent as Outline").value;
  Color get outline => _settings.getSetting("Outline").value;
  Color get error => _settings.getSetting("Error").value;
  Color get onError => _settings.getSetting("On Error").value;

  set accent(Color value) =>
      _settings.getSetting("Accent").setValueWithoutNotify(value);

  ColorSchemeData copy() {
    return ColorSchemeData.from(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'isDefault': _isDefault,
      'settings': _settings.toJson(),
    };
  }

  ColorSchemeData.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _isDefault = json['isDefault'],
        _settings = colorSchemeSettingsSchema.copy() {
    _settings.fromJson(json['settings']);
  }
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
