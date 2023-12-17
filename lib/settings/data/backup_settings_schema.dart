import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:clock_app/app.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:pick_or_save/pick_or_save.dart';

SettingGroup backupSettingsSchema = SettingGroup(
  "Backup",
  description: "Export or Import your settings locally",
  icon: Icons.restore_rounded,
  [
    SettingGroup(
      "Settings",
      [
        SettingAction(
          "Export",
          (context) async {
            saveBackupFile(json.encode(appSettings.valueToJson()), "settings");
          },
          searchTags: ["settings", "export", "backup", "save"],
          description: "Export settings to a local file",
        ),
        SettingAction(
          "Import",
          (context) async {
            loadBackupFile(
              (data) {
                appSettings.loadValueFromJson(json.decode(data));
                appSettings.callAllListeners();
                App.refreshTheme(context);
                appSettings.save();
              },
            );
          },
          searchTags: ["settings", "import", "backup", "load"],
          description: "Import settings from a local file",
        ),
      ],
    ),
  ],
);

saveBackupFile(String data, String label) async {
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(
        fileData: Uint8List.fromList(utf8.encode(data)),
        fileName: "chrono_${label}_backup_${DateTime.now().toIso8601String()}",
      )
    ],
  ));
}

loadBackupFile(Function(String) onSuccess) async {
  List<String>? result = await PickOrSave().filePicker(
    params: FilePickerParams(
      getCachedFilePath: true,
    ),
  );
  if (result != null && result.isNotEmpty) {
    File file = File(result[0]);
    onSuccess(utf8.decode(file.readAsBytesSync()));
  }
}
