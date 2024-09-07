import 'dart:io';

import 'package:clock_app/alarm/screens/alarm_events_screen.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pick_or_save/pick_or_save.dart';

SettingGroup developerSettingsSchema = SettingGroup(
  "Developer Options",
  (context) => AppLocalizations.of(context)!.developerOptionsSettingGroup,
  [
    SettingGroup(
        "Alarm", (context) => AppLocalizations.of(context)!.alarmTitle, [
      SwitchSetting(
        "Show Instant Alarm Button",
        (context) => AppLocalizations.of(context)!.showIstantAlarmButtonSetting,
        kDebugMode,
        // description:
        //     "Show a button on the alarm screen that creates an alarm that rings one second in the future",
      ),
    ]),
    SettingGroup(
        "Logs", (context) => AppLocalizations.of(context)!.logsSettingGroup, [
      SliderSetting(
        "Max logs",
        (context) => AppLocalizations.of(context)!.maxLogsSetting,
        10,
        500,
        100,
        snapLength: 1,
      ),
      SettingPageLink(
          "alarm_logs",
          (context) => AppLocalizations.of(context)!.alarmLogSetting,
          const AlarmEventsScreen()),
      SettingAction(
          "save_logs", (context) => AppLocalizations.of(context)!.saveLogs,
          (context) async {
        final File file = File(await getLogsFilePath());

        if(!(await file.exists())) {
          await file.create(recursive: true);
        }

        await PickOrSave().fileSaver(
            params: FileSaverParams(
          saveFiles: [
            SaveFileInfo(
              fileData: await file.readAsBytes(),
              fileName:
                  "chrono_logs_${DateTime.now().toIso8601String().split(".")[0]}.txt",
            )
          ],
        ));
      }),
      SettingAction(
          "clear_logs", (context) => AppLocalizations.of(context)!.clearLogs,
          (context) async {
        final File file = File(await getLogsFilePath());

        await file.writeAsString("");

        if(context.mounted) showSnackBar(context, "Logs cleared");
      })
    ]),
  ],
  icon: Icons.code_rounded,
);
