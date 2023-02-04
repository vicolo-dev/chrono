import 'package:clock_app/alarm/types/alarm_notification_manager.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

@pragma('vm:entry-point')
void handleAlarmTrigger(int num, Map<String, dynamic> params) async {
  await SettingsManager.initialize();

  // print("Alarm triggered: $num");

  SettingsManager.preferences?.setBool("alarmRecentlyTriggered", true);

  AlarmNotificationManager.showNotification(params);
}
