import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/alarm/types/notification_action.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/notifications/widgets/notification_actions/area_notification_action.dart';
import 'package:clock_app/notifications/widgets/notification_actions/buttons_notification_action.dart';
import 'package:clock_app/notifications/widgets/notification_actions/slide_notification_action.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';


SettingGroup alarmAppSettingsSchema = SettingGroup(
  "Alarm",
  [
    SettingGroup(
      "Default Settings",
      [...alarmSettingsSchema.settingItems],
      description: "Set default settings for new alarms",
      icon: Icons.settings,
    ),
       SelectSetting<NotificationAction>("Dismiss Action Type", searchTags: [
      "action",
      "buttons",
      "slider",
      "slide",
      "area"
    ], [
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
      )
    ]),
    SettingGroup("Filters", [
      SwitchSetting("Show Filters", true),
      SwitchSetting("Show Sort", true),
    ]),
    SettingGroup(
      "Notifications",
      [
        SwitchSetting("Show Upcoming Alarm Notifications", true),
        SliderSetting(
          "Upcoming Lead Time",
          5,
          120,
          10,
          unit: 'm',
          snapLength: 5,
          enableConditions: [
            ValueCondition(
                ["Show Upcoming Alarm Notifications"], (value) => value),
          ],
        ),
        SwitchSetting("Show Snooze Notifications", true),
      ],
    )
  ],
  icon: FluxIcons.alarm,
);
