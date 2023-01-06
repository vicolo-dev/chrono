import 'dart:io';

import 'package:clock_app/data/paths.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Database? database;

Future<void> initializeDatabases() async {
  // If Clock directory doesn't exist, create it

  String appDataPath = await getAppDataDirectoryPath();

  if (!await Directory(appDataPath).exists()) {
    await Directory(appDataPath).create();
  }

  // print('Database path: ${await getMainDatabasePath()}');

  // database = await openDatabase(await getMainDatabasePath(), version: 1,
  //     onCreate: (Database db, int version) async {
  //   await db.execute(
  //       'CREATE TABLE IF NOT EXISTS SavedCities (City String, Timezone String, Country String)');
  // });

  String timezonesDatabasePath = await getTimezonesDatabasePath();

// Only copy if the database doesn't exist
  if (FileSystemEntity.typeSync(timezonesDatabasePath) ==
      FileSystemEntityType.notFound) {
    // Load database from asset and copy
    ByteData data = await rootBundle.load('assets/timezones.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await File(timezonesDatabasePath).writeAsBytes(bytes);
  }

  // sqflite doesn't support Windows and Linux, so we use sqflite_ffi
  // This works on debug builds but for release build on Windows, we need to copy
  // the sqlite3.dll file next to the executable
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
