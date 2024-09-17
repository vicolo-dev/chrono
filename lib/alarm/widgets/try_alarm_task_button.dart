import 'package:clock_app/alarm/screens/try_alarm_task_screen.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class TryAlarmTaskButton extends StatelessWidget {
  const TryAlarmTaskButton({super.key, required this.alarmTask});

  final AlarmTask alarmTask;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return CardContainer(
      color: colorScheme.primary,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TryAlarmTaskScreen(alarmTask: alarmTask),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Try Out",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                )),
          ),
        ),
      ),
    );
  }
}
