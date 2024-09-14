import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:clock_app/alarm/data/alarm_events_list_filters.dart';
import 'package:clock_app/alarm/data/alarm_events_sort_options.dart';
import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/alarm/widgets/alarm_event_card.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AlarmEventsScreen extends StatefulWidget {
  const AlarmEventsScreen({
    super.key,
  });

  @override
  State<AlarmEventsScreen> createState() => _AlarmEventsScreenState();
}

class _AlarmEventsScreenState extends State<AlarmEventsScreen> {
  final _listController = PersistentListController<AlarmEvent>();
  List<SettingItem> searchedItems = [];

  @override
  void initState() {
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
      appBar: const AppTopBar(title: "Alarm Logs"),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: PersistentListView<AlarmEvent>(
                  saveTag: 'alarm_events',
                  listController: _listController,
                  itemBuilder: (event) => AlarmEventCard(
                    key: ValueKey(event),
                    event: event,
                  ),
                  // onTapItem: (fileItem, index) {
                  //   // widget.setting.setValue(context, themeItem);
                  //   // _listController.reload();
                  // },
                  // onDeleteItem: (event){},
                  isDuplicateEnabled: false,
                  isReorderable: false,
                  // isDeleteEnabled: true,
                  placeholderText: "No alarm events",
                  reloadOnPop: true,
                  listFilters: alarmEventsListFilters,
                  sortOptions: alarmEventSortOptions,
                ),
              ),
            ],
          ),
          FAB(
            icon: Icons.delete_rounded,
            bottomPadding: 8,
            onPressed: () async {
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
                final events = await loadList<AlarmEvent>('alarm_events');
                await FilePicker.platform.saveFile(
                  bytes: Uint8List.fromList(utf8.encode(listToString(events))),
                  fileName:
                      "chrono_alarm_events_${DateTime.now().toIso8601String().split(".")[0]}.json",
                );
              } catch (e) {
                logger.e("Error saving alarm events file: ${e.toString()}");
              }
            },
          ),
          FAB(
              index: 2,
              icon: Icons.file_upload,
              bottomPadding: 8,
              onPressed: () async {
                try {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.any, allowMultiple: false);

                  if (result != null && result.files.isNotEmpty) {
                    File file = File(result.files.single.path!);
                    final data = utf8.decode(file.readAsBytesSync());
                    final alarmEvents = listFromString<AlarmEvent>(data);
                    for (var event in alarmEvents) {
                      _listController.addItem(event);
                    }
                  }
                } catch (e) {
                  logger.e("Error loading alarm events file: ${e.toString()}");
                }
              }),

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
