import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class AlarmNotificationScreen extends StatefulWidget {
  const AlarmNotificationScreen({
    Key? key,
    required this.alarm,
  }) : super(key: key);

  final Alarm alarm;

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
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
              dateTime: widget.alarm.timeOfDay.toDateTime(),
              horizontalAlignment: ElementAlignment.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // dismissAlarm(widget.id);
                    // Navigator.pop(context);
                  },
                  child: const Text(alarmSnoozeActionLabel),
                ),
                TextButton(
                  onPressed: () {
                    dismissAlarm();
                    // Navigator.pop(context);
                  },
                  child: const Text(alarmDismissActionLabel),
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
