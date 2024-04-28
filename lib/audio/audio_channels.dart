import 'package:audio_session/audio_session.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<SelectSettingOption<AndroidAudioUsage>> audioChannelOptions = [
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.audioChannelAlarm,
      AndroidAudioUsage.alarm),
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.audioChannelMedia,
      AndroidAudioUsage.media),
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.audioChannelNotification,
      AndroidAudioUsage.notification),
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.audioChannelRingtone,
      AndroidAudioUsage.notificationRingtone),
];
