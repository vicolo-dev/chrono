import 'package:clock_app/app.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/theme/screens/themes_screen.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/theme/utils/style_theme.dart';
import 'package:flutter/material.dart';

enum ThemeBrightness { light, dark, system }

enum DarkMode { user, system, nightDay }

SettingGroup appearanceSettingsSchema = SettingGroup(
  "Appearance",
  [
    SettingGroup(
      "Colors",
      [
        SwitchSetting(
          "Use Material You",
          false,
          onChange: (context, value) => App.refreshTheme(context),
          searchTags: ["primary", "color", "material"],
        ),
        SelectSetting(
            "Brightness",
            [
              SelectSettingOption("System", ThemeBrightness.system),
              SelectSettingOption("Light", ThemeBrightness.light),
              SelectSettingOption("Dark", ThemeBrightness.dark),
            ],
            enableConditions: [
              ValueCondition(["Use Material You"], (value) => value == true)
            ],
            onChange: (context, index) => {App.refreshTheme(context)}),
        SelectSetting(
            "Dark Mode",
            [
              SelectSettingOption("User Defined", DarkMode.user),
              SelectSettingOption("System", DarkMode.system),
              SelectSettingOption("Night/Day", DarkMode.nightDay),
            ],
            enableConditions: [
              ValueCondition(["Use Material You"], (value) => value == false)
            ],
            onChange: (context, index) => {App.refreshTheme(context)}),
        CustomSetting(
          "Color Scheme",
          description:
              "Select from predefined color schemes or create your own",
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
          description:
              "Select from predefined color schemes or create your own",
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
          searchTags: ["theme", "style", "visual", "dark mode", "night mode"],
          enableConditions: [
            ValueCondition(["Use Material You"], (value) => value == false),
            ValueCondition(["Dark Mode"],
                (value) => [DarkMode.system, DarkMode.nightDay].contains(value))
          ],
        ),
        SwitchSetting(
          "Override Accent Color",
          false,
          onChange: (context, value) {
            App.refreshTheme(context);
          },
          searchTags: ["primary", "color", "material you"],
          enableConditions: [
            // ValueCondition(["Use Material You"], (value) => value == false)
          ],
        ),
        ColorSetting("Accent Color", Colors.cyan, onChange: (context, color) {
          App.refreshTheme(context);
        }, enableConditions: [
          ValueCondition(["Override Accent Color"], (value) => value == true),
          // ValueCondition(["Use Material You"], (value) => value == false)
        ], searchTags: [
          "primary",
          "color",
          "material you"
        ]),
      ],
    ),
    SettingGroup(
      "Style",
      [
        SwitchSetting(
          "Use Material Style",
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
          description: "Change styles like shadows, outlines and opacities",
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
  ],
  icon: Icons.palette_outlined,
  description: "Set themes, colors and change layout",
);
