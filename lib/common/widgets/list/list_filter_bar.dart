import 'package:clock_app/common/logic/get_list_filter_chips.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/list/list_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListFilterBar<Item extends ListItem> extends StatelessWidget {
  const ListFilterBar(
      {super.key,
      required this.listFilters,
      required this.customActions,
      required this.sortOptions,
      required this.isSelecting,
      required this.handleCustomAction,
      required this.handleEndSelection,
      required this.handleDeleteAction,
      required this.handleSelectAll,
      required this.selectedIds,
      required this.handleFilterChange,
      required this.selectedSortIndex,
      required this.handleSortChange,
      required this.isDeleteEnabled});

  final List<ListFilterItem<Item>> listFilters;
  final List<ListFilterCustomAction<Item>> customActions;
  final List<ListSortOption<Item>> sortOptions;
  final bool isSelecting;
  final bool isDeleteEnabled;
  final Function(ListFilterCustomAction<Item>) handleCustomAction;
  final Function handleEndSelection;
  final void Function() handleFilterChange;
  final Function handleSelectAll;
  final List<int> selectedIds;
  final int selectedSortIndex;
  final void Function() handleDeleteAction;
  final void Function(int) handleSortChange;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    List<Widget> getFilterChips() {
      List<Widget> widgets = [];
      int activeFilterCount =
          listFilters.where((filter) => filter.isActive).length;
      if (activeFilterCount > 0 || isSelecting) {
        widgets.add(
          ListFilterActionChip(
            actions: [
              ListFilterAction(
                name: AppLocalizations.of(context)!.clearFiltersAction,
                icon: Icons.clear_rounded,
                action: () {
                  for (var filter in listFilters) {
                    filter.reset();
                  }
                  handleEndSelection();
                },
              ),
              ...customActions.map(
                (action) => ListFilterAction(
                  name: action.name,
                  icon: action.icon,
                  action: () => handleCustomAction(action),
                ),
              ),
              if (isDeleteEnabled)
                ListFilterAction(
                  name: AppLocalizations.of(context)!.deleteAllFilteredAction,
                  icon: Icons.delete_rounded,
                  color: colorScheme.error,
                  action: handleDeleteAction,
                )
            ],
            activeFilterCount: activeFilterCount + (isSelecting ? 1 : 0),
          ),
        );
      }

      if (isSelecting) {
        widgets.add(
          ListButtonChip(
            label: AppLocalizations.of(context)!
                .selectionStatus(selectedIds.length),
            icon: Icons.clear_rounded,
            onTap: () => handleEndSelection(),
          ),
        );
        widgets.add(
          ListButtonChip(
            label: AppLocalizations.of(context)!.selectAll,
            icon: Icons.select_all_rounded,
            onTap: () => handleSelectAll(),
          ),
        );
      }
      widgets.addAll(listFilters
          .map((filter) => getListFilterChip(filter, handleFilterChange)));
      if (sortOptions.isNotEmpty) {
        widgets.add(
          ListSortChip(
            selectedIndex: selectedSortIndex,
            sortOptions: [
              ListSortOption(
                  (context) => AppLocalizations.of(context)!.defaultLabel,
                  (a, b) => 0),
              ...sortOptions,
            ],
            onChange: handleSortChange,
          ),
        );
      }
      return widgets;
    }

    return Expanded(
      flex: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AnimatedContainer(
          duration: 150.ms,
          height: getFilterChips().isEmpty ? 0 : 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: getFilterChips(),
            ),
          ),
        ),
      ),
    );
  }
}
