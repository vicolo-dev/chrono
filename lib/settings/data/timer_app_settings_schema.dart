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

SettingGroup timerAppSettingsSchema = SettingGroup(
  "Timer",
  [
    SettingGroup(
      "Default Settings",
      [...timerSettingsSchema.settingItems],
      description: "Set default settings for new timers",
      icon: Icons.settings,
    ),
    SettingPageLink("Presets", const PresetsScreen()),
    SelectSetting<NotificationAction>("Dismiss Action Type", searchTags: [
      "action",
      "buttons",
      "slider",
      "slide",
      "area"
    ], [
      SelectSettingOption(
        "Area Buttons",
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
        "Slide",
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
        "Buttons",
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
    SettingGroup("Filters", [
      SwitchSetting("Show Filters", true),
      SwitchSetting("Show Sort", true),
    ]),
    SwitchSetting("Show Notification", true),
  ],
  icon: FluxIcons.timer,
);
