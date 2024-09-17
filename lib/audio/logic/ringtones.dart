import 'dart:io';
import 'dart:math';

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

Future<List<FileItem>> getSystemRingtones() async {
  final ringtones = (await FlutterSystemRingtones.getAlarmSounds())
      .map((ringtone) => FileItem(
          ringtone.title, ringtone.uri, FileItemType.audio,
          isDeletable: false))
      .toList();

  // If no ringtones are found, add a default one
  if (ringtones.isEmpty) {
    ByteData data = await rootBundle.load("assets/ringtones/default.mp3");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    String path = join(getRingtonesDirectoryPathSync(), "default.mp3");
    await File(path).writeAsBytes(bytes);

    ringtones
        .add(FileItem("Default", path, FileItemType.audio, isDeletable: false));
  }
  return ringtones;
}

Future<String> getDefaultRingtoneUri() async {
  return (await loadList<FileItem>("ringtones"))
      .firstWhere((ringtone) => ringtone.type == FileItemType.audio)
      .uri;
}

Future<int> getRandomRingtoneIndex() async {
  final ringtonesCount = (await loadList<FileItem>("ringtones")).length;
  Random random = Random();
  return random.nextInt(ringtonesCount);
}

Future<List<int>> getNRandomRingtoneIndices(int n) async {
  final ringtonesCount = (await loadList<FileItem>("ringtones")).length;
  Random random = Random();
  List<int> indices = [];
  while (indices.length < n) {
    int index = random.nextInt(ringtonesCount);
    indices.add(index);
  }
  return indices;
}

const methodChannel = MethodChannel('com.vicolo.chrono/documents');

Future<String> getRingtoneUri(FileItem fileItem) async {
  switch (fileItem.type) {
    case FileItemType.directory:
      try {
        List<FileSystemEntity> audioFiles =
            (await Directory(fileItem.uri).list(recursive: true).toList())
                .whereType<File>()
                .where((item) =>
                    lookupMimeType(item.path)?.startsWith('audio/') ?? false)
                .toList();

        if (audioFiles.isNotEmpty) {
          logger.t("Audio files found in directory ${fileItem.uri}");
          Random random = Random();
          int index = random.nextInt(audioFiles.length);
          FileSystemEntity documentFile = audioFiles[index];
          // logger.t("${documentFile.name} ${documentFile.uri}");
          return documentFile.uri.toString();
        } else {
          logger.t(
              "No audio files found in directory ${fileItem.uri}, using default");
          // Choose a default ringtone if directory doesn't have any audio
          return await getDefaultRingtoneUri();
        }
      } catch (e) {
        logger.e("Error loading melody from directory: $e");
        return await getDefaultRingtoneUri();
      }

    case FileItemType.audio:
      return fileItem.uri;

    default:
      return await getDefaultRingtoneUri();
  }
}
