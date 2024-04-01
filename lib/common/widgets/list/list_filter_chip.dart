import 'package:clock_app/common/logic/show_select.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ListFilterChip<Item extends ListItem> extends StatelessWidget {
  const ListFilterChip({
    super.key,
    required this.listFilter,
    required this.onChange,
  });

  final ListFilter<Item> listFilter;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return CardContainer(
      color: listFilter.isSelected ? colorScheme.primary : null,
      onTap: (){
        listFilter.isSelected = !listFilter.isSelected;
        onChange();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          listFilter.name,
          style: textTheme.headlineSmall?.copyWith(
            color: listFilter.isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class ListFilterSelectChip<Item extends ListItem> extends StatefulWidget {
  const ListFilterSelectChip({
    super.key,
    required this.listFilter,
    required this.onChange,
    required this.multiSelect,
  });

  final ListFilterSelect<Item> listFilter;
  final VoidCallback onChange;
  final bool multiSelect;

  @override
  State<ListFilterSelectChip<Item>> createState() =>
      _ListFilterSelectChipState<Item>();
}

class _ListFilterSelectChipState<Item extends ListItem>
    extends State<ListFilterSelectChip<Item>> {
  List<PopupMenuEntry<String>> getItems() {
    List<PopupMenuEntry<String>> items = [];
    for (var filter in widget.listFilter.filters) {
      items.add(PopupMenuItem(value: filter.name, child: Text(filter.name)));
    }
    return items;
  }

  void onSelected(String action) {
    widget.listFilter.selectedFilterIndex = widget.listFilter.filters
        .indexWhere((element) => element.name == action);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    bool isFirstSelected = widget.listFilter.selectedFilterIndex == 0;

    void showSelect() async {
      showSelectBottomSheet(
          context,
          (List<int>? selectedIndices) {
            setState(() {
                widget.listFilter.selectedFilterIndex =
                    selectedIndices?[0] ?? widget.listFilter.selectedFilterIndex;
              });
            widget.onChange();
          },
          title: widget.listFilter.name,
          description: "",
          choices: widget.listFilter.filters
              .map((e) => SelectChoice(name: e.name, value: e.id))
              .toList(),
          initialSelectedIndices: [widget.listFilter.selectedFilterIndex],
          multiSelect: widget.multiSelect);
    }

    print(
        "------------------------------- $isFirstSelected ${widget.listFilter.selectedFilterIndex} ${widget.listFilter.selectedFilter.name}");

    return CardContainer(
      color: widget.listFilter.selectedFilterIndex != 0
          ? colorScheme.primary
          : null,
      onTap: showSelect,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 16.0, right: 2.0),
            child: Text(
              isFirstSelected ? widget.listFilter.name : widget.listFilter.selectedFilter.name,
              style: textTheme.headlineSmall?.copyWith(
                  color: isFirstSelected
                      ? colorScheme.onSurface
                      : colorScheme.onPrimary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 8.0),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isFirstSelected
                  ? colorScheme.onSurface.withOpacity(0.6)
                  : colorScheme.onPrimary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
