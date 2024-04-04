import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';
import 'package:get_storage/get_storage.dart';

Future<void> initializeIsolate() async {
  await initializeAppDataDirectory();
  await initializeStorage(false);
  appSettings.load();
  await initializeNotifications();
  await initializeAudioSession();
  await AndroidAlarmManager.initialize();
  await RingtonePlayer.initialize();
}
