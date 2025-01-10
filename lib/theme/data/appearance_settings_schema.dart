import 'package:clock_app/app.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/theme/screens/themes_screen.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/types/theme_brightness.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup appearanceSettingsSchema = SettingGroup(
  "Appearance",
  (context) => AppLocalizations.of(context)!.appearanceSettingGroup,
  [
    SettingGroup(
      "Colors",
      (context) => AppLocalizations.of(context)!.colorsSettingGroup,
      [
        SwitchSetting(
          "Use Material You",
          (context) => AppLocalizations.of(context)!.useMaterialYouColorSetting,
          false,
          onChange: (context, value) => App.refreshTheme(context),
          searchTags: ["primary", "color", "material"],
        ),
        SelectSetting(
            "Brightness",
            (context) =>
                AppLocalizations.of(context)!.materialBrightnessSetting,
            [
              SelectSettingOption(
                  (context) =>
                      AppLocalizations.of(context)!.materialBrightnessSystem,
                  ThemeBrightness.system),
              SelectSettingOption(
                  (context) =>
                      AppLocalizations.of(context)!.materialBrightnessLight,
                  ThemeBrightness.light),
              SelectSettingOption(
                  (context) =>
                      AppLocalizations.of(context)!.materialBrightnessDark,
                  ThemeBrightness.dark),
            ],
            enableConditions: [
              ValueCondition(["Use Material You"], (value) => value == true)
            ],
            onChange: (context, index) => {App.refreshTheme(context)}),
        SwitchSetting(
            "System Dark Mode",
            (context) => AppLocalizations.of(context)!.systemDarkModeSetting,
            false,
            enableConditions: [
              ValueCondition(["Use Material You"], (value) => value == false)
            ],
            onChange: (context, value) => {App.refreshTheme(context)}),
        CustomSetting(
          "Color Scheme",
          (context) => AppLocalizations.of(context)!.colorSchemeSetting,

          // description:
          //     "Select from predefined color schemes or create your own",
          defaultColorScheme,
          (context, setting) => ThemesScreen(
            saveTag: 'color_schemes',
            setting: setting,
            getThemeFromItem: (theme, themeItem) =>
                getTheme(colorSchemeData: themeItem),
            createThemeItem: () => ColorSchemeData(),
          ),
          (context, setting) => Text(
            setting.value.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChange: (context, colorScheme) async {
            await appSettings.save();
            if (context.mounted) App.refreshTheme(context);
          },
          searchTags: ["theme", "style", "visual", "dark mode"],
          enableConditions: [
            ValueCondition(["Use Material You"], (value) => value == false)
          ],
        ),
        CustomSetting(
          "Dark Color Scheme",
          (context) => AppLocalizations.of(context)!.darkColorSchemeSetting,
          // description:
          //     "Select from predefined color schemes or create your own",
          defaultDarkColorScheme,
          (context, setting) => ThemesScreen(
            saveTag: 'color_schemes',
            setting: setting,
            getThemeFromItem: (theme, themeItem) =>
                getTheme(colorSchemeData: themeItem),
            createThemeItem: () => ColorSchemeData(),
          ),
          (context, setting) => Text(
            setting.value.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChange: (context, colorScheme) async {
            await appSettings.save();
            if (context.mounted) App.refreshTheme(context);
          },
          searchTags: ["theme", "style", "visual", "dark mode", "night mode"],
          enableConditions: [
            ValueCondition(["Use Material You"], (value) => value == false),
            ValueCondition(["System Dark Mode"], (value) => value == true)
          ],
        ),
        SwitchSetting(
          "Override Accent Color",
          (context) => AppLocalizations.of(context)!.overrideAccentSetting,
          false,
          onChange: (context, value) {
            App.refreshTheme(context);
          },
          searchTags: ["primary", "color", "material you"],
          enableConditions: [
            // ValueCondition(["Use Material You"], (value) => value == false)
          ],
        ),
        ColorSetting(
          "Accent Color",
          (context) => AppLocalizations.of(context)!.accentColorSetting,
          Colors.cyan,
          onChange: (context, color) {
            App.refreshTheme(context);
          },
          enableConditions: [
            ValueCondition(["Override Accent Color"], (value) => value == true),
            // ValueCondition(["Use Material You"], (value) => value == false)
          ],
          searchTags: ["primary", "color", "material you"],
        ),
      ],
    ),
    SettingGroup(
      "Style",
      (context) => AppLocalizations.of(context)!.styleSettingGroup,
      [
        SwitchSetting(
          "Use Material Style",
          (context) => AppLocalizations.of(context)!.useMaterialStyleSetting,
          false,
          onChange: (context, value) => App.refreshTheme(context),
          searchTags: [
            "navigation",
            "nav bar",
            "scheme",
            "visual",
            "shadow",
            "outline",
            "elevation",
            "card",
            "border",
            "opacity",
            "blur",
          ],
        ),
        CustomSetting<StyleTheme>(
          "Style Theme",
          (context) => AppLocalizations.of(context)!.styleThemeSetting,
          // description: "Change styles like shadows, outlines and opacities",
          defaultStyleTheme,
          (context, setting) => ThemesScreen(
            saveTag: 'style_themes',
            setting: setting,
            getThemeFromItem: (theme, themeItem) =>
                getTheme(colorScheme: theme.colorScheme, styleTheme: themeItem),
            createThemeItem: () => StyleTheme(),
          ),
          (context, setting) => Text(
            setting.value.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChange: (context, styleTheme) async {
            await appSettings.save();
            if (context.mounted) App.refreshTheme(context);
          },
          searchTags: [
            "scheme",
            "visual",
            "shadow",
            "outline",
            "elevation",
            "card",
            "border",
            "opacity",
            "blur"
          ],
        ),
      ],
    ),
    SettingGroup("Animations",
        (context) => AppLocalizations.of(context)!.animationSettingGroup, [
      SliderSetting(
        "Animation Speed",
        (context) => AppLocalizations.of(context)!.animationSpeedSetting,
        0.5,
        2,
        1,
        snapLength: 0.1,
      ),
      SwitchSetting(
        "Extra Animations",
        (context) => AppLocalizations.of(context)!.extraAnimationSetting,
        false,
        getDescription: (context) =>
            AppLocalizations.of(context)!.extraAnimationSettingDescription,
      ),
    ])
  ],
  icon: Icons.palette_outlined,
  getDescription: (context) =>
      AppLocalizations.of(context)!.appearanceSettingGroupDescription,
);
