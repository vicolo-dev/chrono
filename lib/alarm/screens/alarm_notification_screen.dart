import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  const AlarmNotificationScreen({
    Key? key,
    required this.scheduleId,
  }) : super(key: key);

  final int scheduleId;

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  late Alarm alarm;
  late Widget _currentWidget;
  int _currentIndex = 0;

  void _setNextWidget() {
    setState(() {
      if (_currentIndex >= alarm.tasks.length) {
        _currentWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                AlarmNotificationManager.dismissAlarm(
                    widget.scheduleId, ScheduledNotificationType.alarm);
              },
              child: const Text("Dismiss"),
            ),
          ],
        );
      } else {
        _currentWidget = alarm.tasks[_currentIndex].builder(_setNextWidget);
        _currentIndex++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    alarm = getAlarmByScheduleId(widget.scheduleId);
    _setNextWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClockDisplay(
              dateTime: alarm.time.toDateTime(),
              horizontalAlignment: ElementAlignment.center,
            ),
            _currentWidget,
            if (!alarm.maxSnoozeIsReached)
              TextButton(
                onPressed: () {
                  AlarmNotificationManager.snoozeAlarm(
                      widget.scheduleId, ScheduledNotificationType.alarm);
                },
                child: const Text("Snooze"),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationUtils {}
