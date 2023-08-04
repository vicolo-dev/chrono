import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
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
              SizedBox(
                height: 200,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  children: [
                    for (int id in widget.scheduleIds)
                      CardContainer(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                getTimerById(id).duration.toString(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      AlarmNotificationManager.snoozeAlarm(
                          widget.scheduleIds[0],
                          ScheduledNotificationType.timer);
                    },
                    child: const Text("Add 1 Minute"),
                  ),
                  TextButton(
                    onPressed: () {
                      AlarmNotificationManager.dismissAlarm(
                          widget.scheduleIds[0],
                          ScheduledNotificationType.timer);
                    },
                    child: Text(
                        "Stop ${widget.scheduleIds.length > 1 ? "All" : ""}"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationUtils {}
