import 'dart:io';

import 'package:clock_app/alarm/data/alarm_events_list_filters.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/debug/data/log_list_filters.dart';
import 'package:clock_app/debug/data/log_sort_options.dart';
import 'package:clock_app/debug/types/log.dart';
import 'package:clock_app/debug/widgets/log_card.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:pick_or_save/pick_or_save.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({
    super.key,
  });

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<Log> _logs = [];
  final _listController = ListController<Log>();

  List<String> _mergeMultilineLogs(List<String> logLines) {
    final mergedLogs = <String>[];
    final buffer = StringBuffer();

    for (var line in logLines) {
      if (line.startsWith('[')) {
        if (buffer.isNotEmpty) {
          mergedLogs.add(buffer.toString());
          buffer.clear();
        }
        buffer.writeln(line.trim());
      } else {
        buffer.writeln(line.trim());
      }
    }

    if (buffer.isNotEmpty) {
      mergedLogs.add(buffer.toString());
    }

    // remove new lines from the end of the logs
    for (var i = 0; i < mergedLogs.length; i++) {
      mergedLogs[i] = mergedLogs[i].trim();
    }

    return mergedLogs;
  }

  @override
  void initState() {
    final File file = File(getLogsFilePathSync());
    final content = file.readAsLinesSync();
    final logLines = _mergeMultilineLogs(content);

    for (int i = 0; i < logLines.length; i++) {
      _logs.add(Log.fromLine(logLines[i], i));
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppTopBar(title: Text("App Logs", style: textTheme.titleMedium)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: CustomListView<Log>(
                  items: _logs,
                  listController: _listController,
                  itemBuilder: (log) => LogCard(
                    key: ValueKey(log),
                    log: log,
                  ),
                  // onTapItem: (fileItem, index) {
                  //   // widget.setting.setValue(context, themeItem);
                  //   // _listController.reload();
                  // },
                  // onDeleteItem: (event){},
                  isDuplicateEnabled: false,
                  isReorderable: false,
                  isDeleteEnabled: false,
                  // isDeleteEnabled: true,
                  placeholderText: "No logs",
                  listFilters: logListFilters,
                  sortOptions: logSortOptions,
                  // reloadOnPop: true,
                  // listFilters: alarmEventsListFilters,
                ),
              ),
            ],
          ),
          FAB(
            icon: Icons.delete_rounded,
            bottomPadding: 8,
            onPressed: () async {
              final File file = File(await getLogsFilePath());

              await file.writeAsString("");

              if (context.mounted) showSnackBar(context, "Logs cleared");

              _listController.clearItems();
            },
          ),
          FAB(
              index: 1,
              icon: Icons.file_download,
              bottomPadding: 8,
              onPressed: () async {
                final File file = File(await getLogsFilePath());

                if (!(await file.exists())) {
                  await file.create(recursive: true);
                }

                final result = await PickOrSave().fileSaver(
                    params: FileSaverParams(
                  saveFiles: [
                    SaveFileInfo(
                      fileData: await file.readAsBytes(),
                      fileName:
                          "chrono_logs_${DateTime.now().toIso8601String().split(".")[0]}.txt",
                    )
                  ],
                ));
                if (result != null) {
                  if (context.mounted) {
                    showSnackBar(context, "Logs saved to device");
                  }
                }
              }),
          // FAB(
          //     index: 2,
          //     icon: Icons.file_upload,
          //     bottomPadding: 8,
          //     onPressed: () async {
          //       List<String>? result = await PickOrSave().filePicker(
          //         params: FilePickerParams(
          //           getCachedFilePath: true,
          //         ),
          //       );
          //       if (result != null && result.isNotEmpty) {
          //         File file = File(result[0]);
          //         final data = utf8.decode(file.readAsBytesSync());
          //         final alarmEvents = listFromString<AlarmEvent>(data);
          //         for (var event in alarmEvents) {
          //           _listController.addItem(event);
          //         }
          //       }
          //     }),

          // FAB(
          //   index: 1,
          //   icon: Icons.folder_rounded,
          //   bottomPadding: 8,
          //   onPressed: () async {
          //     // Item? themeItem = widget.createThemeItem();
          //     // await _openCustomizeItemScreen(
          //     //   themeItem,
          //     //   onSave: (newThemeItem) {
          //     //     _listController.addItem(newThemeItem);
          //     //   },
          //     //   isNewItem: true,
          //     // );
          //   },
          // )
        ],
      ),
    );
  }
}
