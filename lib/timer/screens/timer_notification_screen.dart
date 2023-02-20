import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';
import 'package:flutter/material.dart';

class TimerNotificationScreen extends StatefulWidget {
  const TimerNotificationScreen({
    Key? key,
    required this.scheduleId,
  }) : super(key: key);

  final int scheduleId;

  @override
  State<TimerNotificationScreen> createState() =>
      _TimerNotificationScreenState();
}

class _TimerNotificationScreenState extends State<TimerNotificationScreen> {
  late ClockTimer timer;

  @override
  void initState() {
    super.initState();
    timer = getTimerById(widget.scheduleId);
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
            Text(
              timer.duration.toString(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    AlarmNotificationManager.snoozeAlarm(
                        widget.scheduleId, AlarmType.timer);
                    // dismissAlarm(widget.id);
                    // Navigator.pop(context);
                  },
                  child: const Text("Add 1 Minute"),
                ),
                TextButton(
                  onPressed: () {
                    AlarmNotificationManager.dismissAlarm(
                        widget.scheduleId, AlarmType.timer);
                    // Navigator.pop(context);
                  },
                  child: const Text("Stop"),
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
