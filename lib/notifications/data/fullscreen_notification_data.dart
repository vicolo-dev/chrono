import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_data.dart';

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
