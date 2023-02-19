import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class RingtonePlayer {
  static AudioPlayer? _player;
  static bool _vibratorIsAvailable = false;

  static Future<void> initialize() async {
    _player ??= AudioPlayer();
    _vibratorIsAvailable = (await Vibration.hasVibrator()) ?? false;
  }

  static void play(String ringtoneUri,
      {bool vibrate = false, LoopMode loopMode = LoopMode.one}) async {
    RingtoneManager.lastPlayedRingtoneUri = ringtoneUri;
    if (_vibratorIsAvailable && vibrate) {
      Vibration.vibrate(pattern: [500, 1000], repeat: 0);
    }
    await _player?.stop();
    await _player?.setAudioSource(AudioSource.uri(Uri.parse(ringtoneUri)));
    await _player?.setLoopMode(loopMode);
    _player?.play();
  }

  static void stop() async {
    await _player?.stop();
    if (_vibratorIsAvailable) {
      Vibration.cancel();
    }
    RingtoneManager.lastPlayedRingtoneUri = "";
  }
}
