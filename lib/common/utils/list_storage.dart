import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as path;
import 'package:queue/queue.dart';
import 'package:watcher/watcher.dart';

final queue = Queue();
final watcherSubscriptions = <String, StreamSubscription>{};

void watchTextFile(String key, void Function(WatchEvent) callback) {
  String appDataDirectory = getAppDataDirectoryPathSync();
  // File file = File(path.join(appDataDirectory, '$key.txt'));
  // file.watch().listen((event) {
  //   if (event == FileSystemEvent.MODIFY) {
  //     callback(file.readAsStringSync());
  //   }
  // });
  var watcher = FileWatcher(path.join(appDataDirectory, '$key.txt'));
  StreamSubscription subscription = watcher.events.listen(callback);
  watcher.events.listen(callback);
  if (watcherSubscriptions[key] != null) {
    watcherSubscriptions[key]?.cancel();
  }
  watcherSubscriptions[key] = subscription;
}

void unwatchTextFile(String key) {
  watcherSubscriptions[key]?.cancel();
}

void watchList<T extends JsonSerializable>(
    String key, void Function(WatchEvent) callback) {
  watchTextFile(key, (event) async {
    callback(event);
  });
}

void unwatchList(String key) {
  unwatchTextFile(key);
}

List<T> loadListSync<T extends JsonSerializable>(String key) {
  try {
    return listFromString<T>(loadTextFileSync(key));
  } catch (e) {
    logger.e("Error loading list ($key): $e");
    return [];
  }
}

Future<List<T>> loadList<T extends JsonSerializable>(String key) async {
  return listFromString<T>(await loadTextFile(key));
}

Future<void> saveList<T extends JsonSerializable>(
    String key, List<T> list) async {
  await saveTextFile(key, listToString(list));
}

Future<void> initList<T extends JsonSerializable>(
    String key, List<T> list) async {
  await initTextFile(key, listToString(list));
}

Future<void> initTextFile(String key, String value) async {
  if (GetStorage().read('init_$key') == null) {
    GetStorage().write('init_$key', true);
    if (!textFileExistsSync(key)) {
      logger.i("Initializing $key");
      await saveTextFile(key, value);
    }
  }
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

Future<String> saveRingtone(String id, Uint8List data) async {
  String ringtonesDirectory = getRingtonesDirectoryPathSync();
  String newPath = path.join(ringtonesDirectory, id);

  File file = File(newPath);

  await queue.add(() async {
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    await file.writeAsBytes(data, mode: FileMode.writeOnly);
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

bool textFileExistsSync(String key) {
  File file = File(path.join(getAppDataDirectoryPathSync(), '$key.txt'));
  return file.existsSync();
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
