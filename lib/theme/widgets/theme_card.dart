import 'package:clock_app/common/utils/popup_action.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:clock_app/theme/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';

class ThemeCard<Item extends ThemeItem> extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.themeItem,
    required this.onPressEdit,
    required this.isSelected,
    required this.getThemeFromItem,
    required this.onPressDelete,
    required this.onPressDuplicate,
  });

  final Item themeItem;
  final VoidCallback onPressEdit;
  final VoidCallback onPressDelete;
  final VoidCallback onPressDuplicate;
  final bool isSelected;
  final ThemeData Function(ThemeData, Item) getThemeFromItem;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    ThemeData themeData = getThemeFromItem(theme, themeItem);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 8.0, top: 4.0, bottom: 0),
          child: Row(
            children: [
              if (isSelected) Icon(Icons.check, color: colorScheme.primary),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        themeItem.name,
                        style: textTheme.displaySmall
                            ?.copyWith(color: colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: !themeItem.isDefault
                    ? onPressEdit
                    : () {
                        showSnackBar(context,
                            "Default themes cannot be edited. You can duplicate it to edit.",
                            fab: true);
                      },
                icon: Icon(Icons.edit,
                    color: !themeItem.isDefault
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.5)),
              ),
              CardEditMenu(actions: [
                getDuplicatePopupAction(context, onPressDuplicate),
                if (themeItem.isDeletable)
                  getDeletePopupAction(context, onPressDelete),
              ]),
            ],
          ),
        ),
        Theme(
          data: themeData,
          child: const ThemePreviewCard(),
        ),
      ],
    );
  }
}
