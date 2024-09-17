import 'dart:io';

import 'package:clock_app/alarm/data/alarm_events_list_filters.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/common/widgets/list/static_list_view.dart';
import 'package:clock_app/developer/data/log_list_filters.dart';
import 'package:clock_app/developer/data/log_sort_options.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/developer/types/log.dart';
import 'package:clock_app/developer/widgets/log_card.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/navigation/widgets/search_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({
    super.key,
  });

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<Log> _logs = [];
  List<Log> _filteredLogs = [];
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
      appBar: SearchTopBar(
        title: "App Logs",
        searchParams: SearchParams<Log>(
          onSearch: (searchedItems) {
            setState(() {
              _filteredLogs = searchedItems;
            });
          },
          placeholder: "Search logs",
          choices: _logs,
          searchTermGetter: (log) {
            return log.message;
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: _filteredLogs.isEmpty
                    ? CustomListView<Log>(
                        items: _logs,
                        listController: _listController,
                        itemBuilder: (log) => LogCard(
                          key: ValueKey(log),
                          log: log,
                        ),
                        isDuplicateEnabled: false,
                        isReorderable: false,
                        isDeleteEnabled: false,
                        placeholderText: "No logs",
                        listFilters: logListFilters,
                        sortOptions: logSortOptions,
                      )
                    : StaticListView(
                        children: _filteredLogs
                            .map(
                              (log) => CardContainer(
                                child: LogCard(
                                  key: ValueKey(log),
                                  log: log,
                                ),
                              ),
                            )
                            .toList()),
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
              setState(() {});
            },
          ),
          FAB(
              index: 1,
              icon: Icons.file_download,
              bottomPadding: 8,
              onPressed: () async {
                try {
                  final File file = File(await getLogsFilePath());

                  if (!(await file.exists())) {
                    await file.create(recursive: true);
                  }
                  final result = await FilePicker.platform.saveFile(
                    bytes: await file.readAsBytes(),
                    fileName:
                        "chrono_logs_${DateTime.now().toIso8601String().split(".")[0]}.txt",
                  );
                  if (result != null) {
                    if (context.mounted) {
                      showSnackBar(context, "Logs saved to device");
                    }
                  }
                } catch (e) {
                  logger.e("Error saving logs file: ${e.toString()}");
                }
              }),
        ],
      ),
    );
  }
}
