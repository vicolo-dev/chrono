import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/utils/alarm_utils.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  const AlarmNotificationScreen({
    Key? key,
    required this.timeOfDay,
  }) : super(key: key);

  final TimeOfDay? timeOfDay;

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  @override
  void initState() {
    super.initState();
    AlarmAudioPlayer.play();
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
              dateTime: timeOfDayToDateTime(widget.timeOfDay!),
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
