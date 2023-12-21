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

SettingGroup appearanceSettingsSchema = SettingGroup(
  "Appearance",
  [
    SettingGroup(
      "Colors",
      [
        CustomSetting(
          "Color Scheme",
          description:
              "Select from predefined color schemes or create your own",
          defaultColorScheme,
          (context, setting) => ThemesScreen(
            saveTag: 'color_schemes',
            setting: setting,
            getThemeFromItem: (theme, themeItem) =>
                getThemeFromColorScheme(theme, themeItem),
            createThemeItem: () => ColorSchemeData(),
          ),
          (context, setting) => Text(
            setting.value.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChange: (context, colorScheme) {
            App.setColorScheme(context, colorScheme);
            appSettings.save();
          },
          searchTags: ["theme", "style", "visual", "dark mode"],
        ),
        SwitchSetting("Override Accent Color", false,
            onChange: (context, value) {
          App.setColorScheme(context);
        }, searchTags: ["primary", "color"]),
        ColorSetting("Accent Color", Colors.cyan, onChange: (context, color) {
          App.setColorScheme(context);
        }, enableConditions: [
          SettingEnableConditionParameter(["Override Accent Color"], true)
        ], searchTags: [
          "primary",
          "color"
        ]),
      ],
    ),
    SettingGroup(
      "Style",
      [
        CustomSetting<StyleTheme>(
          "Style Theme",
          description: "Change styles like shadows, outlines and opacities",
          defaultStyleTheme,
          (context, setting) => ThemesScreen(
            saveTag: 'style_themes',
            setting: setting,
            getThemeFromItem: (theme, themeItem) =>
                getThemeFromStyleTheme(theme, themeItem),
            createThemeItem: () => StyleTheme(),
          ),
          (context, setting) => Text(
            setting.value.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChange: (context, styleTheme) {
            App.setStyleTheme(context, styleTheme);
            appSettings.save();
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
