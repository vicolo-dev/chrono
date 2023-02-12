import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class RingtoneManager {
  static List<Ringtone> _ringtones = [];
  static String lastPlayedRingtoneUri = "";

  static List<Ringtone> get ringtones => _ringtones;

  static Future<void> initialize() async {
    if (_ringtones.isEmpty) {
      _ringtones = await FlutterSystemRingtones.getAlarmSounds();
    }
  }
}
