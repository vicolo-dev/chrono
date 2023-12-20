import 'package:clock_app/common/types/file_item.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

Future<List<FileItem>> getSystemRingtones() async {
  return (await FlutterSystemRingtones.getAlarmSounds())
      .map((ringtone) =>
          FileItem(ringtone.title, ringtone.uri, isDeletable: false))
      .toList();
}
