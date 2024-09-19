import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/fields/input_bottom_sheet.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/widgets/tag_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({
    super.key,
  });

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final _listController = PersistentListController<Tag>();

  Future<Tag?> showTagEditor([Tag? initialTag]) async {
    Tag newTag = Tag.from(initialTag ?? Tag("New Preset"));

    String? tagName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return InputBottomSheet(
              title: AppLocalizations.of(context)!.editTagLabel,
              description: "",
              initialValue: newTag.name,
              hintText: AppLocalizations.of(context)!.tagNamePlaceholder,
              onChange: (value) {},
            );
          },
        );
      },
    );
    newTag.name = tagName ?? newTag.name;
    return newTag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: AppLocalizations.of(context)!.tagsSetting),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PersistentListView<Tag>(
                  saveTag: 'tags',
                  listController: _listController,
                  itemBuilder: (tag) => TagCard(
                    key: ValueKey(tag),
                    tag: tag,
                    onPressDelete: () => _listController.deleteItem(tag),
                    onPressDuplicate: () => _listController.duplicateItem(tag),
                  ),
                  onTapItem: (tag, index) async {
                    Tag? newTag = await showTagEditor(tag);
                    if (newTag == null) return;
                    tag.copyFrom(newTag);
                    _listController.changeItems((tags) {});
                  },
                  // onDeleteItem: _handleDeleteTimer,
                  placeholderText: "No tags created",
                  reloadOnPop: true,
                  isSelectable: true,
                ),
              ),
            ],
          ),
          FAB(
            bottomPadding: 8,
            onPressed: () async {
              Tag? tag = await showTagEditor();
              if (tag == null) return;
              _listController.addItem(tag);
            },
          )
        ],
      ),
    );
  }
}
