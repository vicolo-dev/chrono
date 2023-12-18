import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:flutter/material.dart';

class FileItemCard extends StatefulWidget {
  const FileItemCard({
    Key? key,
    required this.fileItem,
    required this.onPressDelete,
  }) : super(key: key);

  final FileItem fileItem;
  final VoidCallback onPressDelete;

  @override
  State<FileItemCard> createState() => _FileItemCardState();
}

class _FileItemCardState extends State<FileItemCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 4, top: 8, bottom: 8),
        child: Row(
          children: [
            Icon(Icons.music_note_rounded, color: colorScheme.primary),
            SizedBox(width: 4),
            Expanded(
              flex: 999,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fileItem.title,
                    style: Theme.of(context).textTheme.displaySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            CardEditMenu(
              onPressDelete: widget.onPressDelete,
            ),
          ],
        ));
  }
}
