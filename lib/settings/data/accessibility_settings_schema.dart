import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup accessibilitySettingsSchema = SettingGroup(
  "Accessibility",
  (context) => AppLocalizations.of(context)!.accessibilitySettingGroup,
  [
    SwitchSetting("Left Handed Mode",
        (context) => AppLocalizations.of(context)!.leftHandedSetting, false)
  ],
  icon: Icons.accessibility_new_rounded,
  showExpandedView: false,
);
