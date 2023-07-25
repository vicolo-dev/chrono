import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';

SettingGroup styleThemeSettingsSchema = SettingGroup(
  "App Style",
  [
    StringSetting("Name", "Style Theme"),
    SettingGroup("Shape", [
      SliderSetting("Corner Roundness", 0, 36, 16),
    ]),
    SettingGroup("Shadow", [
      SliderSetting("Elevation", 0, 10, 1),
      SliderSetting("Opacity", 0, 100, 20),
      SliderSetting("Blur", 0, 16, 1),
      SliderSetting("Spread", 0, 8, 0),
    ]),
    SettingGroup("Outline", [
      SliderSetting("Width", 0, 8, 0),
    ]),
  ],
);
