import 'dart:convert';
import 'dart:io';

import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/file_item_card.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:pick_or_save/pick_or_save.dart';

class RingtonesScreen extends StatefulWidget {
  const RingtonesScreen({
    super.key,
  });

  @override
  State<RingtonesScreen> createState() => _RingtonesScreenState();
}

class _RingtonesScreenState extends State<RingtonesScreen> {
  final _listController = PersistentListController<FileItem>();
  List<SettingItem> searchedItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    RingtonePlayer.stop();
    super.dispose();
  }

  void _onDeleteItem(FileItem fileItem) {
    if (!fileItem.isDeletable) return;
    final file = File(fileItem.uri);
    file.deleteSync();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppTopBar(title: Text("Melodies", style: textTheme.titleMedium)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: PersistentListView<FileItem>(
                  saveTag: 'ringtones',
                  listController: _listController,
                  itemBuilder: (fileItem) => FileItemCard(
                    key: ValueKey(fileItem),
                    fileItem: fileItem,
                    onPressDelete: () => _listController.deleteItem(fileItem),
                  ),
                  onTapItem: (fileItem, index) {
                    // widget.setting.setValue(context, themeItem);
                    // _listController.reload();
                  },
                  onDeleteItem: _onDeleteItem,
                  isDuplicateEnabled: false,
                  placeholderText: "No melodies",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            // icon: Icons.music_note_rounded,
            bottomPadding: 8,
            onPressed: () async {
              RingtonePlayer.stop();
              List<String>? result = await PickOrSave().filePicker(
                params: FilePickerParams(
                  mimeTypesFilter: ['audio/*'],
                  getCachedFilePath: true,
                  enableMultipleSelection: true,
                ),
              );
              if (result != null && result.isNotEmpty) {
                for (String uri in result) {
                  final metadata = await PickOrSave()
                      .fileMetaData(params: FileMetadataParams(filePath: uri));
                  final fileItem =
                      FileItem(metadata.displayName ?? "File", uri);
                  fileItem.uri =
                      await saveRingtone(fileItem.id.toString(), uri);
                  _listController
                      .addItem(FileItem(metadata.displayName ?? "File", uri));
                }
              }

              // Item? themeItem = widget.createThemeItem();
              // await _openCustomizeItemScreen(
              //   themeItem,
              //   onSave: (newThemeItem) {
              //     _listController.addItem(newThemeItem);
              //   },
              //   isNewItem: true,
              // );
            },
          ),
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
