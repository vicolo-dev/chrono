import 'package:clock_app/audio/types/audio.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class RingtoneManager {
  static List<Audio> _ringtones = [];
  static String lastPlayedRingtoneUri = "";

  static List<Audio> get ringtones => _ringtones;

  static Future<void> initialize() async {
    if (_ringtones.isEmpty) {
      _ringtones = (await FlutterSystemRingtones.getAlarmSounds())
          .map((ringtone) =>
              Audio(id: ringtone.id, title: ringtone.title, uri: ringtone.uri))
          .toList();
    }
  }
}
