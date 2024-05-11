import 'package:audio_session/audio_session.dart';

Future<void> initializeAudioSession(
    [AndroidAudioUsage usage = AndroidAudioUsage.alarm]) async {
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration(
    androidAudioAttributes: AndroidAudioAttributes(
      usage: usage,
      contentType: AndroidAudioContentType.music,

    ),
  ));
}
