import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/file_item.dart';
import 'package:clock_app/common/utils/popup_action.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class FileItemCard extends StatefulWidget {
  const FileItemCard({
    super.key,
    required this.fileItem,
    required this.onPressDelete,
  });

  final FileItem fileItem;
  final VoidCallback onPressDelete;

  @override
  State<FileItemCard> createState() => _FileItemCardState();
}

class _FileItemCardState extends State<FileItemCard> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    RingtoneManager.addListener(_updateIsPlaying);
    _updateIsPlaying();
  }

  @override
  void dispose() {
    RingtoneManager.removeListener(_updateIsPlaying);
    super.dispose();
  }

  void _updateIsPlaying() {
    setState(() {
      isPlaying = RingtoneManager.lastPlayedRingtoneUri == widget.fileItem.uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () async {
        if (widget.fileItem.type == FileItemType.audio) {
          if (RingtoneManager.lastPlayedRingtoneUri == widget.fileItem.uri) {
            await RingtonePlayer.stop();
            _updateIsPlaying();
          } else {
            RingtonePlayer.playUri(widget.fileItem.uri, loopMode: LoopMode.all);
            _updateIsPlaying();
          }
        }
      },
      child: Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 4, top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(getFileItemIcon(widget.fileItem, isPlaying), color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                flex: 999,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    widget.fileItem.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ),
              if (widget.fileItem.isDeletable)
                CardEditMenu(
                  actions: [
                    getDeletePopupAction(context, widget.onPressDelete)
                  ],
                ),
            ],
          )),
    );
  }
}
