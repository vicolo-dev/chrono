import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/popup_action.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:flutter/material.dart';

class ListFilterSettingCard extends StatefulWidget {
  const ListFilterSettingCard({
    super.key,
    required this.listFilter,
    required this.onEnabledChange,
  });

  final ListFilterItem listFilter;
  final void Function(bool) onEnabledChange;

  @override
  State<ListFilterSettingCard> createState() => _ListFilterSettingCardState();
}

class _ListFilterSettingCardState extends State<ListFilterSettingCard> {
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
                    widget.listFilter.displayName(context),
                    style: Theme.of(context).textTheme.displaySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            Switch(
                value: widget.listFilter.isEnabled,
                onChanged: widget.onEnabledChange)
          ],
        ));
  }
}
