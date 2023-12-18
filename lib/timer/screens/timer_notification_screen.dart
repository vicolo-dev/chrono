import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';
import 'package:flutter/material.dart';

class TimerNotificationScreen extends StatefulWidget {
  const TimerNotificationScreen({
    Key? key,
    required this.scheduleIds,
  }) : super(key: key);

  final List<int> scheduleIds;

  @override
  State<TimerNotificationScreen> createState() =>
      _TimerNotificationScreenState();
}

class _TimerNotificationScreenState extends State<TimerNotificationScreen> {
  late Widget actionWidget = appSettings
      .getGroup("Timer")
      .getSetting("Dismiss Action Type")
      .value
      .builder(
        _stop,
        _addTime,
        "Stop ${widget.scheduleIds.length > 1 ? "All" : ""}",
        '+${getTimerById(widget.scheduleIds.last).addLength.floor()}:00',
      );

  void _addTime() {
    AlarmNotificationManager.snoozeAlarm(
        widget.scheduleIds[0], ScheduledNotificationType.timer);
  }

  void _stop() {
    AlarmNotificationManager.dismissAlarm(
        widget.scheduleIds[0], ScheduledNotificationType.timer);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Routes.pop(onlyUpdateRoute: true);
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: ListView(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 16, left: 32, right: 32),
                  children: [
                    for (int id in widget.scheduleIds)
                      TimerNotificationCard(timer: getTimerById(id)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    actionWidget,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerNotificationCard extends StatelessWidget {
  const TimerNotificationCard({
    super.key,
    required this.timer,
  });

  final ClockTimer timer;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              timer.label,
              style: Theme.of(context).textTheme.displayMedium,
            )));
  }
}

class NotificationUtils {}
