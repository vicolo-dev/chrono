import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/theme/data/style_theme_settings_schema.dart';
import 'package:clock_app/theme/types/theme_item.dart';

class StyleTheme extends ThemeItem {
  StyleTheme({
    String name = "Style Theme",
    double shadowElevation = 1,
    double shadowOpacity = 0.2,
    double shadowBlurRadius = 1,
    double shadowSpreadRadius = 0,
    double borderRadius = 16,
    double borderWidth = 0,
    bool isDefault = false,
  }) : super(styleThemeSettingsSchema.copy(), isDefault) {
    settings.getSetting("Name").setValueWithoutNotify(name);
    settings
        .getGroup("Shadow")
        .getSetting("Elevation")
        .setValueWithoutNotify(shadowElevation);
    settings
        .getGroup("Shadow")
        .getSetting("Opacity")
        .setValueWithoutNotify(shadowOpacity * 100);
    settings
        .getGroup("Shadow")
        .getSetting("Blur")
        .setValueWithoutNotify(shadowBlurRadius);
    settings
        .getGroup("Shadow")
        .getSetting("Spread")
        .setValueWithoutNotify(shadowSpreadRadius);
    settings
        .getGroup("Shape")
        .getSetting("Corner Roundness")
        .setValueWithoutNotify(borderRadius);
    settings
        .getGroup("Outline")
        .getSetting("Width")
        .setValueWithoutNotify(borderWidth);
  }

  StyleTheme.from(StyleTheme super.colorSchemeData) : super.from();

  @override
  String get name => settings.getSetting("Name").value;

  double get shadowElevation =>
      settings.getGroup("Shadow").getSetting("Elevation").value;
  double get shadowOpacity =>
      settings.getGroup("Shadow").getSetting("Opacity").value / 100;
  double get shadowBlurRadius =>
      settings.getGroup("Shadow").getSetting("Blur").value;
  double get shadowSpreadRadius =>
      settings.getGroup("Shadow").getSetting("Spread").value;
  double get borderRadius =>
      settings.getGroup("Shape").getSetting("Corner Roundness").value;
  double get borderWidth =>
      settings.getGroup("Outline").getSetting("Width").value;

  @override
  StyleTheme copy() {
    return StyleTheme.from(this);
  }

  StyleTheme.fromJson(Json json)
      : super.fromJson(json, styleThemeSettingsSchema.copy());

  bool isEqualTo(StyleTheme other) {
    return name == other.name &&
        shadowElevation == other.shadowElevation &&
        shadowOpacity == other.shadowOpacity &&
        shadowBlurRadius == other.shadowBlurRadius &&
        shadowSpreadRadius == other.shadowSpreadRadius &&
        borderRadius == other.borderRadius &&
        borderWidth == other.borderWidth;
  }
}
