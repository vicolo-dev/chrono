import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const colorSchemeSettingsSchemaVersion = 1;

SettingGroup colorSchemeSettingsSchema = SettingGroup(
  version: colorSchemeSettingsSchemaVersion,
  "Color Scheme",
  (context) => AppLocalizations.of(context)!.colorsSettingGroup,
  [
    StringSetting("Name", (context) => AppLocalizations.of(context)!.nameField,
        "Color Scheme"),
    SettingGroup(
        "Background",
        (context) =>
            AppLocalizations.of(context)!.colorSchemeBackgroundSettingGroup,
        [
          ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.white),
          ColorSetting(
              "Text",
              (context) => AppLocalizations.of(context)!.textColorSetting,
              Colors.black),
        ]),
    SettingGroup(
        "Card",
        (context) => AppLocalizations.of(context)!.colorSchemeCardSettingGroup,
        [
          ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.white),
          ColorSetting(
              "Text",
              (context) => AppLocalizations.of(context)!.textColorSetting,
              Colors.black),
        ]),
    SettingGroup(
        "Accent",
        (context) =>
            AppLocalizations.of(context)!.colorSchemeAccentSettingGroup,
        [
          ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.cyan),
          ColorSetting(
              "Text",
              (context) => AppLocalizations.of(context)!.textColorSetting,
              Colors.white),
        ]),
    SettingGroup(
        "Shadow",
        (context) =>
            AppLocalizations.of(context)!.colorSchemeShadowSettingGroup,
        [
          SwitchSetting(
              "Use Accent as Shadow",
              (context) => AppLocalizations.of(context)!
                  .colorSchemeUseAccentAsShadowSetting,
              false),
          ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.black,
              enableConditions: [
                ValueCondition(
                    ["Use Accent as Shadow"], (value) => value == false),
              ]),
        ]),
    SettingGroup(
        "Outline",
        (context) =>
            AppLocalizations.of(context)!.colorSchemeOutlineSettingGroup,
        [
          SwitchSetting(
              "Use Accent as Outline",
              (context) => AppLocalizations.of(context)!
                  .colorSchemeUseAccentAsOutlineSetting,
              false),
          ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.black,
              enableConditions: [
                ValueCondition(
                    ["Use Accent as Outline"], (value) => value == false),
              ]),
        ]),
    SettingGroup(
        "Error",
        (context) => AppLocalizations.of(context)!.colorSchemeErrorSettingGroup,
        [
          ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.red),
          ColorSetting(
              "Text",
              (context) => AppLocalizations.of(context)!.textColorSetting,
              Colors.white),
        ]),
  ],
);
