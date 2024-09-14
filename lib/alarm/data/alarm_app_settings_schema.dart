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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup alarmAppSettingsSchema = SettingGroup(
  "Alarm",
  (context) => AppLocalizations.of(context)!.alarmTitle,
  [
    SettingGroup(
      "Default Settings",
      (context) => AppLocalizations.of(context)!.defaultSettingGroup,
      [...alarmSettingsSchema.settingItems],
      getDescription: (context) =>
          AppLocalizations.of(context)!.alarmsDefaultSettingGroupDescription,
      icon: Icons.settings,
    ),
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
          )
        ]),
    SettingGroup("Filters",
        (context) => AppLocalizations.of(context)!.filtersSettingGroup, [
      SwitchSetting("Show Filters",
          (context) => AppLocalizations.of(context)!.showFiltersSetting, true),
      SwitchSetting("Show Sort",
          (context) => AppLocalizations.of(context)!.showSortSetting, true),
          SwitchSetting("Show Next Alarm",
          (context) => AppLocalizations.of(context)!.showNextAlarm, false),

    ]),
    SettingGroup(
      "Notifications",
      (context) => AppLocalizations.of(context)!.notificationsSettingGroup,
      [
        SwitchSetting(
            "Show Upcoming Alarm Notifications",
            (context) => AppLocalizations.of(context)!
                .showUpcomingAlarmNotificationSetting,
            true),
        SliderSetting(
          "Upcoming Lead Time",
          (context) => AppLocalizations.of(context)!.upcomingLeadTimeSetting,
          5,
          600,
          10,
          unit: 'm',
          snapLength: 5,
          enableConditions: [
            ValueCondition(
                ["Show Upcoming Alarm Notifications"], (value) => value),
          ],
        ),
        SwitchSetting(
            "Show Snooze Notifications",
            (context) =>
                AppLocalizations.of(context)!.showSnoozeNotificationSetting,
            true),
      ],
    )
  ],
  icon: FluxIcons.alarm,
);
