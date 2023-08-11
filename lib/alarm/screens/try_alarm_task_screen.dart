import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';

class TryAlarmTaskScreen extends StatelessWidget {
  const TryAlarmTaskScreen({Key? key, required this.alarmTask})
      : super(key: key);

  final AlarmTask alarmTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          alarmTask.builder(() {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }
}
