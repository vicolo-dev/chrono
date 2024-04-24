import 'dart:io';

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:path/path.dart';

Future<List<FileItem>> getSystemRingtones() async {
  final ringtones = (await FlutterSystemRingtones.getAlarmSounds())
      .map((ringtone) =>
          FileItem(ringtone.title, ringtone.uri, FileItemType.audio, isDeletable: false))
      .toList();

  // If no ringtones are found, add a default one
  if (ringtones.isEmpty) {
    ByteData data = await rootBundle.load("assets/ringtones/default.mp3");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    String path = join(getRingtonesDirectoryPathSync(), "default.mp3");
    await File(path).writeAsBytes(bytes);

    ringtones.add(FileItem("Default", path, FileItemType.audio, isDeletable: false));
  }
  return ringtones;
}
