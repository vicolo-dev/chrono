import 'dart:io';

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:queue/queue.dart';

final queue = Queue();

List<T> loadListSync<T extends JsonSerializable>(String key) {
  return listFromString<T>(loadTextFileSync(key));
}

Future<List<T>> loadList<T extends JsonSerializable>(String key) async {
  return listFromString<T>(await loadTextFile(key));
}

Future<void> saveList<T extends JsonSerializable>(
    String key, List<T> list) async {
  await saveTextFile(key, listToString(list));
}

Future<void> saveTextFile(String key, String content) async {
  await queue.add(() async {
    String appDataDirectory = getAppDataDirectoryPathSync();
    File file = File(path.join(appDataDirectory, '$key.txt'));
    if (!file.existsSync()) {
      file.createSync();
    }
    await file.writeAsString(content, mode: FileMode.writeOnly);
  });
}

Future<String> saveRingtone(String id, String sourceUri) async {
  String ringtonesDirectory = getRingtonesDirectoryPathSync();
  File source = File(sourceUri);
  String newPath = path.join(ringtonesDirectory, '$id.mp3');
  await queue.add(() async {
    await source.copy(newPath);
  });
  return newPath;
}

String loadTextFileSync<T extends JsonSerializable>(String key) {
  File file = File(path.join(getAppDataDirectoryPathSync(), '$key.txt'));
  try {
    return file.readAsStringSync();
  } catch (error) {
    throw Exception("Failed to load list from file '$key': $error");
  }
}

Future<String> loadTextFile(String key) async {
  final String content = await queue.add(() async {
    String appDataDirectory = getAppDataDirectoryPathSync();
    File file = File(path.join(appDataDirectory, '$key.txt'));

    if (file.existsSync()) {
      return file.readAsString();
    } else {
      return '[]';
    }
  });
  return content;
}
