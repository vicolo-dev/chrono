import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';

Future<void> updateTimerNotification(ClockTimer timer, int count) async {
  // print("------------ ${timer.remainingSeconds.toDouble() /
  //           timer.currentDuration.inSeconds.toDouble()}");
  List<NotificationActionButton> actionButtons = [];

  if (count == 1) {
    actionButtons.addAll([
      NotificationActionButton(
        showInCompactView: true,
        key: "timer_toggle_state",
        label: timer.isRunning ? 'Pause' : 'Start',
        actionType: ActionType.SilentAction,
        autoDismissible: false,
      ),
      NotificationActionButton(
        showInCompactView: true,
        key: "timer_add",
        label: '+${timer.addLength.floor()}:00',
        actionType: ActionType.SilentAction,
        autoDismissible: false,
      ),
      NotificationActionButton(
        showInCompactView: true,
        key: "timer_reset",
        label: 'Reset',
        actionType: ActionType.SilentAction,
        autoDismissible: false,
      ),
    ]);
  } else {
    actionButtons.add(NotificationActionButton(
      showInCompactView: true,
      key: "timer_reset_all",
      label: 'Reset all',
      actionType: ActionType.SilentAction,
      autoDismissible: false,
    ));
  }

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 2,
      channelKey: timerNotificationChannelKey,
      title:
          "${timer.label.isEmpty ? 'Timer' : timer.label}${count > 1 ? ' + ${count-1} timers' : ''}",
      body: TimeDuration.fromSeconds(timer.remainingSeconds).toTimeString(),
      category: NotificationCategory.Progress,
      notificationLayout: NotificationLayout.ProgressBar,
      payload: {
        "scheduleId": '${timer.id}',
      },
      progress: 100 -
          (timer.remainingSeconds.toDouble() /
                  timer.currentDuration.inSeconds.toDouble()) *
              100,
    ),
    actionButtons: actionButtons,
  );
}
