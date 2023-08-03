import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

class AlarmTaskCard extends StatelessWidget {
  const AlarmTaskCard({Key? key, required this.task, this.onTap})
      : super(key: key);

  final AlarmTask task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.name, style: textTheme.displaySmall),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
