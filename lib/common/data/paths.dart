import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const appDataDirectory = "Clock";

Future<void> initializeAppDataDirectory() async {
  String appDataPath = await getAppDataDirectoryPath();

  if (!await Directory(appDataPath).exists()) {
    await Directory(appDataPath).create();
  }
}

Future<String> getAppDataDirectoryPath() async {
  return path.join(
      (await getApplicationDocumentsDirectory()).path, appDataDirectory);
}

Future<String> getTimezonesDatabasePath() async {
  return path.join(await getAppDataDirectoryPath(), 'timezones.db');
}

// Future<String> getMainDatabasePath() async {
//   return path.join(await getDatabasesPath(), 'database.db');
// }
