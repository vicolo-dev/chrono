import 'dart:io';

import 'package:clock_app/data/paths.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> initializeDatabase() async {
  // If Clock directory doesn't exist, create it

  String appDataPath = await getAppDataDirectoryPath();

  if (!await Directory(appDataPath).exists()) {
    await Directory(appDataPath).create();
  }

  String databasePath = await getTimezonesDatabasePath();

// Only copy if the database doesn't exist
  if (FileSystemEntity.typeSync(databasePath) ==
      FileSystemEntityType.notFound) {
    // Load database from asset and copy
    ByteData data = await rootBundle.load('assets/timezones.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await File(databasePath).writeAsBytes(bytes);
  }

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
