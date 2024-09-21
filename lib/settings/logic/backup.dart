import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<String?> saveBackupFile(String data) async {
  return await FilePicker.platform.saveFile(
    bytes: Uint8List.fromList(utf8.encode(data)),
    fileName:
        "chrono_backup_${DateTime.now().toIso8601String().split(".")[0]}.json",
  );
}

Future<String?> loadBackupFile() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.any, allowMultiple: false);

  if (result != null && result.files.isNotEmpty) {
    File file = File(result.files.single.path!);
    return utf8.decode(file.readAsBytesSync());
  }
  return null;
}
