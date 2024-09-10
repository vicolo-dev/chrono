import 'dart:io';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/file_item_card.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/widgets/settings_top_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if (fileItem.type != FileItemType.directory) {
      final file = File(fileItem.uri);
      file.deleteSync();
    }
    RingtonePlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: SettingsTopBar(
        title: AppLocalizations.of(context)!.melodiesSetting,
      ),
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
                  isSelectable: true,
                ),
              ),
            ],
          ),
          FAB(
            icon: Icons.music_note_rounded,
            bottomPadding: 8,
            onPressed: () async {
              RingtonePlayer.stop();
              FilePickerResult? result = await FilePicker.platform
                  .pickFiles(type: FileType.audio, allowMultiple: true);

              // The result will be null, if the user aborted the dialog
              if (result != null && result.files.isNotEmpty) {
                for (PlatformFile file in result.files) {
                  logger.t("Saving melody ${file.name}, size ${file.size}");
                  final bytes = await file.xFile.readAsBytes();
                  final fileItem = FileItem(file.name, "", FileItemType.audio);
                  fileItem.uri =
                      await saveRingtone(fileItem.id.toString(), bytes);
                  _listController.addItem(fileItem);
                }
              }
            },
          ),
          FAB(
            index: 1,
            icon: Icons.create_new_folder_rounded,
            bottomPadding: 8,
            onPressed: () async {
              RingtonePlayer.stop();
              String? selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();

              if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
                // logger.t("selectedDirectory: $selectedDirectory");

                final directory = Directory(selectedDirectory);
                final List<FileSystemEntity> entities =
                    await directory.list().toList();

                // logger.t(entities);

                String name = basename(selectedDirectory
                    .replaceAll("%3A", "/")
                    .replaceAll("%2F", "/"));
                final fileItem =
                    FileItem(name, selectedDirectory, FileItemType.directory);
                _listController.addItem(fileItem);
              }
            },
          )
        ],
      ),
    );
  }
}
