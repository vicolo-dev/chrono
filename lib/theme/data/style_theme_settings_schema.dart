import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const styleThemeSettingsSchemaVersion = 1;

SettingGroup styleThemeSettingsSchema = SettingGroup(
  version: styleThemeSettingsSchemaVersion,
  "App Style",
  (context) => AppLocalizations.of(context)!.styleSettingGroup,
  [
    StringSetting("Name", (context) => AppLocalizations.of(context)!.nameField,
        "Style Theme"),
    SettingGroup(
        "Shape",
        (context) => AppLocalizations.of(context)!.styleThemeShapeSettingGroup,
        [
          SliderSetting(
              "Corner Roundness",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeRadiusSetting,
              0,
              36,
              16),
        ]),
    SettingGroup(
        "Shadow",
        (context) => AppLocalizations.of(context)!.styleThemeShadowSettingGroup,
        [
          SliderSetting(
              "Elevation",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeElevationSetting,
              0,
              10,
              1),
          SliderSetting(
              "Opacity",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeOpacitySetting,
              0,
              100,
              20),
          SliderSetting(
              "Blur",
              (context) => AppLocalizations.of(context)!.styleThemeBlurSetting,
              0,
              16,
              1),
          SliderSetting(
              "Spread",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeSpreadSetting,
              0,
              8,
              0),
        ]),
    SettingGroup(
        "Outline",
        (context) =>
            AppLocalizations.of(context)!.styleThemeOutlineSettingGroup,
        [
          SliderSetting(
              "Width",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeOutlineWidthSetting,
              0,
              8,
              0),
        ]),
  ],
);
