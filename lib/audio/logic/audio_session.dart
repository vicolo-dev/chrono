import 'package:audio_session/audio_session.dart';

Future<void> initializeAudioSession(
    [AndroidAudioUsage usage = AndroidAudioUsage.media]) async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    // androidAudioAttributes: AndroidAudioAttributes(
    //   usage: usage,
    //   contentType: AndroidAudioContentType.music,
    // ),
    androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
    androidWillPauseWhenDucked: false,
  ));
}
