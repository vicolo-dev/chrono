import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pick_or_save/pick_or_save.dart';

void saveBackupFile(String data) async {
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(
        fileData: Uint8List.fromList(utf8.encode(data)),
        fileName: "chrono_backup_${DateTime.now().toIso8601String().split(".")[0]}.json",
      )
    ],
  ));
}

Future<String?> loadBackupFile() async {
  List<String>? result = await PickOrSave().filePicker(
    params: FilePickerParams(
      getCachedFilePath: true,
    ),
  );
  if (result != null && result.isNotEmpty) {
    File file = File(result[0]);
    return utf8.decode(file.readAsBytesSync());
  }
  return null;
}
