import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:just_audio/just_audio.dart';

class AlarmAudioPlayer {
  static AudioPlayer? _player;
  static List<Ringtone> _ringtones = [];
  static int _lastPlayedRingtoneIndex = -1;

  static List<Ringtone> get ringtones => _ringtones;
  static int get lastPlayedRingtoneIndex => _lastPlayedRingtoneIndex;

  static Future<void> initialize() async {
    _player = AudioPlayer();
    _ringtones = await FlutterSystemRingtones.getAlarmSounds();
  }

  static void play(int ringtoneIndex,
      {LoopMode loopMode = LoopMode.one}) async {
    _lastPlayedRingtoneIndex = ringtoneIndex;
    _player?.stop();
    await _player?.setAudioSource(
        AudioSource.uri(Uri.parse(ringtones[ringtoneIndex].uri)));
    await _player?.setLoopMode(loopMode);
    _player?.play();
  }

  static void stop() {
    print("Is Player Playing: ${_player?.playing}");
    print("Is Player Null: ${_player == null}");
    _player?.stop();
    _lastPlayedRingtoneIndex = -1;
  }
}
