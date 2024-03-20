import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class RingtoneManager {
  // static List<FileItem> _ringtones = [];
  // static List<FileItem> _customRingtones = [];
  static String _lastPlayedRingtoneUri = "";

  static final List<void Function()> _listeners = [];

  // static List<FileItem> get ringtones => _ringtones;
  // static List<FileItem> get customRingtones => _customRingtones;
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

  // static Future<void> updateCustomRingtones() async {
  //   _customRingtones = await loadList<FileItem>('ringtones');
  // }

  // static Future<void> initialize() async {
  //   if (_ringtones.isEmpty) {
  //     _ringtones = await getSystemRingtones();
  //   }
  //   if (_customRingtones.isEmpty) {
  //     _customRingtones = await loadList<FileItem>('ringtones');
  //   }
  // }
}
