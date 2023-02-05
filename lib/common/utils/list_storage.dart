import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/json_serialize.dart';

List<T> loadList<T extends JsonSerializable>(String key) {
  String appDataDirectory = getAppDataDirectoryPathSync();
  File file = File(path.join(appDataDirectory, '$key.txt'));
  try {
    final String encodedList = file.readAsStringSync();
    return decodeList<T>(encodedList);
  } catch (e) {
    print(e);
    return [];
  }
}

Future<void> saveList<T extends JsonSerializable>(
    String key, List<T> list) async {
  String appDataDirectory = getAppDataDirectoryPathSync();
  File file = File(path.join(appDataDirectory, '$key.txt'));
  if (!file.existsSync()) {
    file.createSync();
  }
  print('Saving list to ${file.path}...');
  file.writeAsString(encodeList(list), mode: FileMode.writeOnly);
}
