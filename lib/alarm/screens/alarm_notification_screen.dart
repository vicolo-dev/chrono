import 'dart:ui';

import 'package:clock_app/alarm/logic/alarm_isolate.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/widgets/clock/clock.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/notifications/widgets/notification_actions/slide_notification_action.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  const AlarmNotificationScreen({
    super.key,
    required this.scheduleId,
    this.onPop,
    this.initialIndex = -1,
    this.dismissType = AlarmDismissType.dismiss,
  });

  final int scheduleId;
  final int initialIndex;
  final Function? onPop;
  final AlarmDismissType dismissType;

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  late Alarm alarm;
  late Widget _currentWidget;
  late int _currentIndex = widget.initialIndex;
  late Widget actionWidget;
  void _setNextWidget() {
    setState(() {
      if (_currentIndex < 0) {
        IsolateNameServer.lookupPortByName(setAlarmVolumePortName)
            ?.send([alarm.volume]);
        _currentWidget = actionWidget;
      } else if (_currentIndex >= alarm.tasks.length) {
        if (widget.onPop != null) {
          widget.onPop!();
          Navigator.of(context).pop(true);
        } else {
          AlarmNotificationManager.dismissNotification(widget.scheduleId,
              widget.dismissType, ScheduledNotificationType.alarm);
        }
      } else {
        IsolateNameServer.lookupPortByName(setAlarmVolumePortName)
            ?.send([alarm.volume * alarm.volumeDuringTasks / 100]);
        // RingtonePlayer.setVolume(0);
        _currentWidget = alarm.tasks[_currentIndex].builder(_setNextWidget);
      }
      _currentIndex++;
    });
  }

  @override
  void initState() {
    super.initState();

    Alarm? currentAlarm = getAlarmById(widget.scheduleId);
    if (currentAlarm == null) {
      AlarmNotificationManager.dismissNotification(widget.scheduleId,
          widget.dismissType, ScheduledNotificationType.alarm);
      return;
    }
    alarm = currentAlarm;

    try {
      actionWidget = appSettings
          .getGroup("Alarm")
          .getSetting("Dismiss Action Type")
          .value
          .builder(_setNextWidget, alarm.canBeSnoozed ? _snoozeAlarm : null,
              "Dismiss", "Snooze");
    } catch (e) {
      actionWidget = SlideNotificationAction(
        onDismiss: _setNextWidget,
        onSnooze: alarm.canBeSnoozed ? _snoozeAlarm : null,
        dismissLabel: "Dismiss",
        snoozeLabel: "Snooze",
      );

      logger.e(e.toString());
    }

    _setNextWidget();
  }

  void _snoozeAlarm() {
    AlarmNotificationManager.snoozeAlarm(
        widget.scheduleId, ScheduledNotificationType.alarm);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Routes.pop(onlyUpdateRoute: true);
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_currentIndex <= 0)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Spacer(),
                        if (alarm.label.isNotEmpty)
                          Text(
                            alarm.label,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        const SizedBox(height: 8),
                        const Clock(
                          // dateTime: Date,
                          horizontalAlignment: ElementAlignment.center,
                          shouldShowDate: false,
                          shouldShowSeconds: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Alarm",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _currentWidget,
                    ],
                  ),
                ),
                // if (!alarm.maxSnoozeIsReached)
                //   TextButton(
                //     onPressed: _snoozeAlarm,
                //     child: const Text("Snooze"),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationUtils {}
