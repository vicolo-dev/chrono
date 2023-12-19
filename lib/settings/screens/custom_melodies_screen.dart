import 'dart:convert';

import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/file_item_card.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:pick_or_save/pick_or_save.dart';

class CustomMelodiesScreen extends StatefulWidget {
  const CustomMelodiesScreen({
    super.key,
  });

  @override
  State<CustomMelodiesScreen> createState() => _CustomMelodiesScreenState();
}

class _CustomMelodiesScreenState extends State<CustomMelodiesScreen> {
  final _listController = PersistentListController<FileItem>();
  List<SettingItem> searchedItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> getSearchItemWidgets() {
    //   return searchedItems.map((item) {
    //     return SearchSettingCard(settingItem: item);
    //   }).toList();
    // }

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppTopBar(
          title: Text("Custom Melodies", style: textTheme.titleMedium)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: PersistentListView<FileItem>(
                  saveTag: 'melodies',
                  listController: _listController,
                  itemBuilder: (fileItem) => FileItemCard(
                    key: ValueKey(fileItem),
                    fileItem: fileItem,
                    onPressDelete: () => _listController.deleteItem(fileItem),
                  ),
                  // onTapItem: (themeItem, index) {
                  //   widget.setting.setValue(context, themeItem);
                  //   _listController.reload();
                  // },
                  // onDeleteItem: _onDeleteItem,
                  isDuplicateEnabled: false,
                  placeholderText: "No custom melodies",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            // icon: Icons.music_note_rounded,
            bottomPadding: 8,
            onPressed: () async {
              List<String>? result = await PickOrSave().filePicker(
                params: FilePickerParams(
                  mimeTypesFilter: ['audio/*'],
                  getCachedFilePath: false,
                  enableMultipleSelection: true,
                ),
              );
              if (result != null && result.isNotEmpty) {
                for (String uri in result) {
                  bool? persistentPermStatus =
                      await PickOrSave().uriPermissionStatus(
                    params: UriPermissionStatusParams(
                      uri: uri,
                      releasePermission: false,
                    ),
                  );
                  print("Is persistent $uri: $persistentPermStatus");
                  final metadata = await PickOrSave()
                      .fileMetaData(params: FileMetadataParams(filePath: uri));
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
