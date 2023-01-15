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

  static void play(int ringtoneIndex,
      {LoopMode loopMode = LoopMode.one}) async {
    _player.stop();
    await _player.setAudioSource(
        AudioSource.uri(Uri.parse(ringtones[ringtoneIndex].uri)));
    await _player.setLoopMode(loopMode);
    _player.play();
  }

  static void stop() {
    _player.stop();
  }
}
