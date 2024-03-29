import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/navigation/types/routes.dart';

class FullScreenNotificationData {
  int id;
  final String route;

  FullScreenNotificationData({
    required this.id,
    required this.route,
  });
}

typedef Payload = Json;

Map<ScheduledNotificationType, FullScreenNotificationData>
    alarmNotificationData = {
  ScheduledNotificationType.alarm: FullScreenNotificationData(
    id: 0,
    route: Routes.alarmNotificationRoute,
  ),
  ScheduledNotificationType.timer: FullScreenNotificationData(
    id: 1,
    route: Routes.timerNotificationRoute,
  ),
};
