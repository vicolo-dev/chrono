import 'package:audio_session/audio_session.dart';

Future<void> initializeAudioSession() async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    androidAudioAttributes: AndroidAudioAttributes(
      usage: AndroidAudioUsage.alarm,
      contentType: AndroidAudioContentType.music,
    ),
  ));
}
