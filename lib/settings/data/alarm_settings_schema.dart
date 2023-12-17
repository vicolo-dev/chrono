import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/alarm/types/notification_action.dart';
import 'package:clock_app/alarm/widgets/notification_actions/area_notification_action.dart';
import 'package:clock_app/alarm/widgets/notification_actions/buttons_notification_action.dart';
import 'package:clock_app/alarm/widgets/notification_actions/slide_notification_action.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
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
      "action"
    ], [
      SelectSettingOption(
        "Slide",
        NotificationAction(
          builder: (onDismiss, onSnooze) => SlideNotificationAction(
            onDismiss: onDismiss,
            onSnooze: onSnooze,
          ),
        ),
      ),
      SelectSettingOption(
        "Buttons",
        NotificationAction(
          builder: (onDismiss, onSnooze) => ButtonsNotificationAction(
            onDismiss: onDismiss,
            onSnooze: onSnooze,
          ),
        ),
      ),
      SelectSettingOption(
        "Area Buttons",
        NotificationAction(
          builder: (onDismiss, onSnooze) => AreaNotificationAction(
            onDismiss: onDismiss,
            onSnooze: onSnooze,
          ),
        ),
      )
    ]),
    SwitchSetting("Show Filters", true),
  ],
  icon: FluxIcons.alarm,
);
