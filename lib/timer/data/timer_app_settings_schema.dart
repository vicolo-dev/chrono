import 'package:clock_app/alarm/types/notification_action.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/notifications/widgets/notification_actions/area_notification_action.dart';
import 'package:clock_app/notifications/widgets/notification_actions/buttons_notification_action.dart';
import 'package:clock_app/notifications/widgets/notification_actions/slide_notification_action.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/timer/data/timer_settings_schema.dart';
import 'package:clock_app/timer/screens/presets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup timerAppSettingsSchema = SettingGroup(
  "Timer",
  (context) => AppLocalizations.of(context)!.timerTitle,
  [
    SettingGroup(
      "Default Settings",
      (context) => AppLocalizations.of(context)!.defaultSettingGroup,
      [...timerSettingsSchema.settingItems],
      getDescription: (context) =>
          AppLocalizations.of(context)!.timerDefaultSettingGroupDescription,
      icon: Icons.settings,
    ),
    SettingPageLink(
        "Presets",
        (context) => AppLocalizations.of(context)!.presetsSetting,
        const PresetsScreen()),
    SelectSetting<NotificationAction>(
        "Dismiss Action Type",
        (context) => AppLocalizations.of(context)!.dismissActionSetting,
        searchTags: [
          "action",
          "buttons",
          "slider",
          "slide",
          "area"
        ],
        [
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.dismissActionAreaButtons,
            NotificationAction(
              builder: (onDismiss, onSnooze, dismissLabel, snoozeLabel) =>
                  AreaNotificationAction(
                onDismiss: onDismiss,
                onSnooze: onSnooze,
                dismissLabel: dismissLabel,
                snoozeLabel: snoozeLabel,
              ),
            ),
          ),
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.dismissActionSlide,
            NotificationAction(
              builder: (onDismiss, onSnooze, dismissLabel, snoozeLabel) =>
                  SlideNotificationAction(
                onDismiss: onDismiss,
                onSnooze: onSnooze,
                dismissLabel: dismissLabel,
                snoozeLabel: snoozeLabel,
              ),
            ),
          ),
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.dismissActionButtons,
            NotificationAction(
              builder: (onDismiss, onSnooze, dismissLabel, snoozeLabel) =>
                  ButtonsNotificationAction(
                onDismiss: onDismiss,
                onSnooze: onSnooze,
                dismissLabel: dismissLabel,
                snoozeLabel: snoozeLabel,
              ),
            ),
          ),
        ]),
    SettingGroup("Filters",
        (context) => AppLocalizations.of(context)!.filtersSettingGroup, [
      SwitchSetting("Show Filters",
          (context) => AppLocalizations.of(context)!.showFiltersSetting, true),
      SwitchSetting("Show Sort",
          (context) => AppLocalizations.of(context)!.showSortSetting, true),
    ]),
    SwitchSetting(
        "Show Notification",
        (context) => AppLocalizations.of(context)!.showNotificationSetting,
        true),
  ],
  icon: FluxIcons.timer,
);
