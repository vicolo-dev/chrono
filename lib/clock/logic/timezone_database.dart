import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clock_app/common/data/paths.dart';
import 'package:path/path.dart';
// Database? database;

Future<void> initializeDatabases() async {
  String timezonesDatabasePath = await getTimezonesDatabasePath();

  // Only copy if the database doesn't exist
  if (FileSystemEntity.typeSync(timezonesDatabasePath) ==
      FileSystemEntityType.notFound) {
    // Load database from asset and copy
    ByteData data = await rootBundle.load(join('assets', 'timezones.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    debugPrint('Copying timzones.db to $timezonesDatabasePath');
    // debugPrint(json.encode(bytes));
    // Save copied asset to documents
    await File(timezonesDatabasePath).writeAsBytes(bytes);
  }
}
