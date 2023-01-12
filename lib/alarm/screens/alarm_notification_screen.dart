import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  const AlarmNotificationScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int? id;

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // dismissAlarm(widget.id);
                    // Navigator.pop(context);
                  },
                  child: const Text(snoozeActionLabel),
                ),
                TextButton(
                  onPressed: () {
                    dismissAlarm();
                    // Navigator.pop(context);
                  },
                  child: const Text(dismissActionLabel),
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
