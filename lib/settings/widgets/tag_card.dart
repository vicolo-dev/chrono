import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/popup_action.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:flutter/material.dart';

class TagCard extends StatefulWidget {
  const TagCard({
    super.key,
    required this.tag,
    required this.onPressDelete,
    required this.onPressDuplicate,
  });

  final Tag tag;
  final VoidCallback onPressDelete;
  final VoidCallback onPressDuplicate;

  @override
  State<TagCard> createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 4, top: 8, bottom: 8),
        child: Row(
          children: [
            Expanded(
              flex: 999,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tag.name,
                    style: Theme.of(context).textTheme.displaySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            CardEditMenu(actions: [
              getDuplicatePopupAction(context, widget.onPressDuplicate),
              getDeletePopupAction(context, widget.onPressDelete),
            ]),
          ],
        ));
  }
}
