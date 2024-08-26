import 'package:clock_app/settings/logic/backup.dart';
import 'package:clock_app/settings/screens/backup_screen.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup backupSettingsSchema = SettingGroup(
  "Backup",
  (context) => AppLocalizations.of(context)!.backupSettingGroup,
  getDescription: (context) =>
      AppLocalizations.of(context)!.backupSettingGroupDescription,
showExpandedView:  false,
  icon: Icons.restore_rounded,
  [
        SettingPageLink(
          "Export",
          (context) => AppLocalizations.of(context)!.exportSettingsSetting,
          const BackupExportScreen(),
          getDescription: (context) =>
              AppLocalizations.of(context)!.exportSettingsSettingDescription,
        ),
        SettingAction(
          "Import",
          (context) => AppLocalizations.of(context)!.importSettingsSetting,
          (context) async {
            final data = await loadBackupFile();
            if(data == null) return;
            if (context.mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BackupImportScreen(data: data)));
            }
          },
          getDescription: (context) =>
              AppLocalizations.of(context)!.importSettingsSettingDescription,
        ),
        // SettingAction(
        //   "Export",
        //   (context) => AppLocalizations.of(context)!.exportSettingsSetting,
        //   (context) async {
        //     saveBackupFile(json.encode(appSettings.valueToJson()), "settings");
        //   },
        //   searchTags: ["settings", "export", "backup", "save"],
        //   getDescription: (context) =>
        //       AppLocalizations.of(context)!.exportSettingsSettingDescription,
        // ),
        // SettingAction(
        //   "Import",
        //   (context) => AppLocalizations.of(context)!.importSettingsSetting,
        //   (context) async {
        //     loadBackupFile(
        //       (data) async {
        //         appSettings.loadValueFromJson(json.decode(data));
        //         appSettings.callAllListeners();
        //         App.refreshTheme(context);
        //         await appSettings.save();
        //         if (context.mounted) setDigitalClockWidgetData(context);
        //       },
        //     );
        //   },
        //   searchTags: ["settings", "import", "backup", "load"],
        //   getDescription: (context) =>
        //       AppLocalizations.of(context)!.importSettingsSettingDescription,
        // ),
  ],
);
