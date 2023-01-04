import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<void> initializeDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String databasePath = path.join(documentsDirectory.path, "timezones.db");

// Only copy if the database doesn't exist
  if (FileSystemEntity.typeSync(databasePath) ==
      FileSystemEntityType.notFound) {
    // Load database from asset and copy
    ByteData data = await rootBundle.load(path.join('assets', 'timezones.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await File(databasePath).writeAsBytes(bytes);
  }
}
