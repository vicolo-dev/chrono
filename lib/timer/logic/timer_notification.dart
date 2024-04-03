import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';

Future<void> updateTimerNotification(ClockTimer timer) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: timer.id,
        channelKey: stopwatchNotificationChannelKey,
        title: timer.label.isEmpty ? 'Timer' : timer.label,
        body:
           TimeDuration.fromSeconds(timer.remainingSeconds).toTimeString(),
        category: NotificationCategory.Progress,
        notificationLayout: NotificationLayout.ProgressBar,
            progress: timer.remainingSeconds.toDouble() / timer.currentDuration.inSeconds.toDouble(),
      ),
      actionButtons: [
        NotificationActionButton(
          showInCompactView: true,
          key: "timer_toggle_state",
          label: timer.isRunning ? 'Pause' : 'Start',
          actionType: ActionType.SilentAction,
          autoDismissible: false,
        ),
        NotificationActionButton(
          showInCompactView: true,
          key: "stopwatch_reset",
          label: '+${timer.addLength.floor()}:00',
          actionType: ActionType.SilentAction,
          autoDismissible: false,
        ),
             ]);
}
