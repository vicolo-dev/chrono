import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const _appDataDirectory = "Clock";
const _ringtonesDirectory = "ringtones";
String _appDataDirectoryPath = "";

Future<void> initializeAppDataDirectory() async {
  _appDataDirectoryPath = await getAppDataDirectoryPath();

  if (!await Directory(_appDataDirectoryPath).exists()) {
    await Directory(_appDataDirectoryPath).create();
  }

  await Directory(getRingtonesDirectoryPathSync()).create(recursive: true);
}

String getAppDataDirectoryPathSync() {
  if (_appDataDirectoryPath.isEmpty) {
    throw Exception(
        "App data directory path is not initialized. Call 'initializeAppDataDirectory()' first.");
  }
  return _appDataDirectoryPath;
}

Future<String> getAppDataDirectoryPath() async {
  return path.join(
      (await getApplicationDocumentsDirectory()).path, _appDataDirectory);
}

Future<String> getRingtonesDirectoryPath() async {
  return path.join(await getAppDataDirectoryPath(), _ringtonesDirectory);
}

String getRingtonesDirectoryPathSync() {
  return path.join(getAppDataDirectoryPathSync(), _ringtonesDirectory);
}

Future<String> getTimezonesDatabasePath() async {
  return path.join(await getAppDataDirectoryPath(), 'timezones.db');
}

Future<String> getLogsFilePath() async {
  return path.join(await getAppDataDirectoryPath(), "logs.txt");
}
