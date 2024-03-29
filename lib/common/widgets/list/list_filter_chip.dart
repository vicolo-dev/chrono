import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ListFilterChip<Item extends ListItem> extends StatelessWidget {
  const ListFilterChip(
      {super.key,
      required this.listFilter,
      required this.onTap,
      required this.isSelected});

  final ListFilter<Item> listFilter;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return CardContainer(
      color: isSelected ? colorScheme.primary : null,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          listFilter.name,
          style: textTheme.headlineSmall?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
