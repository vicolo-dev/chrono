import 'package:clock_app/alarm/screens/try_alarm_task_screen.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class TryAlarmTaskButton extends StatelessWidget {
  const TryAlarmTaskButton({Key? key, required this.alarmTask})
      : super(key: key);

  final AlarmTask alarmTask;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CardContainer(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TryAlarmTaskScreen(alarmTask: alarmTask),
            ),
          );
        },
        child: Text("Try Out", style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
