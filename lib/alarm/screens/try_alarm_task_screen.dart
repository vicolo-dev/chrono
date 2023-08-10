import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:flutter/material.dart';

class TryAlarmTaskScreen extends StatelessWidget {
  const TryAlarmTaskScreen({Key? key, required this.alarmTask})
      : super(key: key);

  final AlarmTask alarmTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            alarmTask.builder(() {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}
