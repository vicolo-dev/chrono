import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/navigation/types/routes.dart';

class FullScreenNotificationData {
  int id;
  final String snoozeActionLabel;
  final String dismissActionLabel;
  final String route;

  FullScreenNotificationData({
    required this.id,
    required this.snoozeActionLabel,
    required this.dismissActionLabel,
    required this.route,
  });
}

typedef Payload = Json;

Map<ScheduledNotificationType, FullScreenNotificationData>
    alarmNotificationData = {
  ScheduledNotificationType.alarm: FullScreenNotificationData(
    id: 0,
    snoozeActionLabel: "Snooze",
    dismissActionLabel: "Dismiss",
    route: Routes.alarmNotificationRoute,
  ),
  ScheduledNotificationType.timer: FullScreenNotificationData(
    id: 1,
    snoozeActionLabel: "Add 1 Minute",
    dismissActionLabel: "Stop",
    route: Routes.timerNotificationRoute,
  ),
};
