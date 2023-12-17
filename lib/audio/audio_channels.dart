import 'package:audio_session/audio_session.dart';
import 'package:clock_app/settings/types/setting.dart';

List<SelectSettingOption<AndroidAudioUsage>> audioChannelOptions = [
  SelectSettingOption("Alarm", AndroidAudioUsage.alarm),
  SelectSettingOption("Media", AndroidAudioUsage.media),
  SelectSettingOption("Notification", AndroidAudioUsage.notification),
  SelectSettingOption("Ringtone", AndroidAudioUsage.notificationRingtone),
];
