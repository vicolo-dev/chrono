import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

class AlarmTaskCard extends StatelessWidget {
  const AlarmTaskCard({Key? key, required this.task, required this.isAddCard})
      : super(key: key);

  final AlarmTask task;
  final bool isAddCard;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: isAddCard ? 8.0 : 16.0,
              bottom: isAddCard ? 8.0 : 16.0),
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
              if (!isAddCard) const Icon(FluxIcons.settings),
            ],
          ),
        ),
      ],
    );
  }
}
