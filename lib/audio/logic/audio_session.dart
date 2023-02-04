import 'package:audio_session/audio_session.dart';

Future<void> initializeAudioSession() async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions:
        AVAudioSessionCategoryOptions.defaultToSpeaker,
    androidAudioAttributes: AndroidAudioAttributes(
      flags: AndroidAudioFlags.audibilityEnforced,
      usage: AndroidAudioUsage.alarm,
    ),
  ));
}
