import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:just_audio/just_audio.dart';

class AlarmAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();
  static List<Ringtone> _ringtones = [];

  static AudioPlayer get player => _player;
  static List<Ringtone> get ringtones => _ringtones;

  static Future<void> initialize() async {
    _ringtones = await FlutterSystemRingtones.getAlarmSounds();
  }

  static void play({int ringtoneIndex = 0}) async {
    if (!_player.playing) {
      await _player.setAudioSource(
          AudioSource.uri(Uri.parse(ringtones[ringtoneIndex].uri)));
      _player.setLoopMode(LoopMode.one);
      _player.play();
    }
  }

  static void stop() {
    _player.stop();
  }
}
