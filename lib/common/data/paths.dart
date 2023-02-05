import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const _appDataDirectory = "Clock";
String _appDataDirectoryPath = "";

Future<void> initializeAppDataDirectory() async {
  _appDataDirectoryPath = await getAppDataDirectoryPath();

  if (!await Directory(_appDataDirectoryPath).exists()) {
    await Directory(_appDataDirectoryPath).create();
  }
}

String getAppDataDirectoryPathSync() {
  return _appDataDirectoryPath;
}

Future<String> getAppDataDirectoryPath() async {
  return path.join(
      (await getApplicationDocumentsDirectory()).path, _appDataDirectory);
}

Future<String> getTimezonesDatabasePath() async {
  return path.join(await getAppDataDirectoryPath(), 'timezones.db');
}

// Future<String> getMainDatabasePath() async {
//   return path.join(await getDatabasesPath(), 'database.db');
// }
