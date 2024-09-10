import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:flutter/material.dart';

class AlarmEventCard extends StatelessWidget {
  const AlarmEventCard({super.key, required this.event});

  final AlarmEvent event;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;

    Color textColor = colorScheme.onSurface.withOpacity(0.8);

    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(event.isActive ? "Active" : "Inactive",
              style: textTheme.labelMedium?.copyWith(
                  color: event.isActive
                      ? colorScheme.primary
                      : colorScheme.onSurface)),
          Text('Scheduled for: ${event.startDate}',
              style: textTheme.labelMedium?.copyWith(color: textColor)),
          Text(
              'Type: ${event.notificationType == ScheduledNotificationType.alarm ? "Alarm" : "Timer"}',
              style: textTheme.labelMedium?.copyWith(color: textColor)),
          Text('Created at: ${event.eventTime}',
              style: textTheme.labelMedium?.copyWith(color: textColor)),
          Text(
            'Description: ${event.description}',
            style: textTheme.labelMedium?.copyWith(color: textColor),
            maxLines: 5,
          ),
          Text('Schedule Id: ${event.scheduleId}',
              style: textTheme.labelMedium?.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
