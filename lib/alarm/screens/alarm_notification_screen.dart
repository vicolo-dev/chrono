import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
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

  @override
  void initState() {
    super.initState();
    alarm = getAlarmByScheduleId(widget.scheduleId);
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
              dateTime: alarm.timeOfDay.toDateTime(),
              horizontalAlignment: ElementAlignment.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    AlarmNotificationManager.snoozeAlarm(
                        widget.scheduleId, AlarmType.alarm);
                    // dismissAlarm(widget.id);
                    // Navigator.pop(context);
                  },
                  child: const Text("Snooze"),
                ),
                TextButton(
                  onPressed: () {
                    AlarmNotificationManager.dismissAlarm(
                        widget.scheduleId, AlarmType.alarm);
                    // Navigator.pop(context);
                  },
                  child: const Text("Dismiss"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationUtils {}
