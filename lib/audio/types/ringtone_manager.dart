import 'package:clock_app/audio/types/audio.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class RingtoneManager {
  static List<Audio> _ringtones = [];
  static String _lastPlayedRingtoneUri = "";

  static final List<void Function()> _listeners = [];

  static List<Audio> get ringtones => _ringtones;
  static List<void Function()> get listeners => _listeners;
  static String get lastPlayedRingtoneUri => _lastPlayedRingtoneUri;
  static set lastPlayedRingtoneUri(String uri) {
    _lastPlayedRingtoneUri = uri;
    for (var listener in _listeners) {
      listener();
    }
  }

  static void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  static void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  static Future<void> initialize() async {
    if (_ringtones.isEmpty) {
      _ringtones = (await FlutterSystemRingtones.getAlarmSounds())
          .map((ringtone) =>
              Audio(id: ringtone.id, title: ringtone.title, uri: ringtone.uri))
          .toList();
    }
  }
}
