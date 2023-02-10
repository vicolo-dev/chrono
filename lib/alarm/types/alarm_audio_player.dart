import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:just_audio/just_audio.dart';

class AlarmAudioPlayer {
  static AudioPlayer? _player;

  static Future<void> initialize() async {
    _player ??= AudioPlayer();
  }

  static void play(String uri, {LoopMode loopMode = LoopMode.one}) async {
    RingtoneManager.lastPlayedRingtoneUri = uri;
    _player?.stop();
    await _player?.setAudioSource(AudioSource.uri(Uri.parse(uri)));
    await _player?.setLoopMode(loopMode);
    _player?.play();
  }

  static void stop() {
    _player?.stop();
    RingtoneManager.lastPlayedRingtoneUri = "";
  }
}
