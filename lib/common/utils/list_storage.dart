import 'dart:io';

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:path/path.dart' as path;
import 'package:queue/queue.dart';

final queue = Queue();

List<T> loadListSync<T extends JsonSerializable>(String key) {
  // GetStorage storage = GetStorage();
  // String encodedList = storage.read(key);
  // return decodeList<T>(encodedList);
  String appDataDirectory = getAppDataDirectoryPathSync();
  File file = File(path.join(appDataDirectory, '$key.txt'));
  try {
    final String encodedList = file.readAsStringSync();
    return decodeList<T>(encodedList);
  } catch (error) {
    throw Exception("Failed to load list from file '$key': $error");
  }
}

Future<List<T>> loadList<T extends JsonSerializable>(String key) async {
  // GetStorage storage = GetStorage();
  // String encodedList = storage.read(key);
  // return decodeList<T>(encodedList);
  final String encodedList = await queue.add(() async {
    String appDataDirectory = getAppDataDirectoryPathSync();
    File file = File(path.join(appDataDirectory, '$key.txt'));
    try {
      return file.readAsString();
    } catch (error) {
      return '';
    }
  });
  return decodeList<T>(encodedList);
}

Future<void> saveList<T extends JsonSerializable>(
    String key, List<T> list) async {
  // GetStorage storage = GetStorage();
  // String encodedList = encodeList(list);
  // await storage.write(key, encodedList);

  await queue.add(() async {
    String appDataDirectory = getAppDataDirectoryPathSync();
    File file = File(path.join(appDataDirectory, '$key.txt'));
    if (!file.existsSync()) {
      file.createSync();
    }
    String encodedList = encodeList(list);

    await file.writeAsString(encodedList, mode: FileMode.writeOnly);
  });
}
