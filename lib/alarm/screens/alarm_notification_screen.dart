import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  const AlarmNotificationScreen({
    super.key,
    required this.scheduleId,
    this.onDismiss,
    this.initialIndex = -1,
  });

  final int scheduleId;
  final int initialIndex;
  final Function? onDismiss;

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  late Alarm alarm;
  late Widget _currentWidget;
  late int _currentIndex = widget.initialIndex;
  late Widget actionWidget = appSettings
      .getGroup("Alarm")
      .getSetting("Dismiss Action Type")
      .value
      .builder(_setNextWidget, alarm.canBeSnoozed ? _snoozeAlarm : null,
          "Dismiss", "Snooze");

  void _setNextWidget() {
    setState(() {
      if (_currentIndex == -1) {
        _currentWidget = actionWidget;
      } else if (_currentIndex >= alarm.tasks.length) {
        if (widget.onDismiss != null) {
          widget.onDismiss!();
          Navigator.of(context).pop(true);
        } else {
          AlarmNotificationManager.dismissAlarm(
              widget.scheduleId, ScheduledNotificationType.alarm);
        }
      } else {
        _currentWidget = alarm.tasks[_currentIndex].builder(_setNextWidget);
      }
      _currentIndex++;
    });
  }

  @override
  void initState() {
    super.initState();
    alarm = getAlarmByScheduleId(widget.scheduleId);
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
                        ClockDisplay(
                          dateTime: alarm.time.toDateTime(),
                          horizontalAlignment: ElementAlignment.center,
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
