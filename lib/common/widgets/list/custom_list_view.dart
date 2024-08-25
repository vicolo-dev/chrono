import 'package:clock_app/common/logic/get_list_filter_chips.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/list/delete_alert_dialogue.dart';
import 'package:clock_app/common/widgets/list/list_filter_chip.dart';
import 'package:clock_app/common/widgets/list/list_item_card.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef ItemCardBuilder = Widget Function(
  BuildContext context,
  int index,
  AnimatedWidgetBuilderData data,
);

class CustomListView<Item extends ListItem> extends StatefulWidget {
  const CustomListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.listController,
    this.onTapItem,
    this.onReorderItem,
    this.onDeleteItem,
    this.onAddItem,
    this.placeholderText = '',
    // Called whenever an item is added, deleted or reordered
    this.onModifyList,
    this.isReorderable = true,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
    this.shouldInsertOnTop = true,
    this.isSelectable = false,
    this.listFilters = const [],
    this.customActions = const [],
    this.sortOptions = const [],
    this.initialSortIndex = 0,
    this.onChangeSortIndex,
    this.header,
  });

  final List<Item> items;
  final Widget Function(Item item) itemBuilder;
  final void Function(Item item, int index)? onTapItem;
  final Function(Item item)? onReorderItem;
  final Function(Item item)? onDeleteItem;
  final Function(Item item)? onAddItem;
  // Called whenever an item is added, deleted or reordered
  final void Function()? onModifyList;
  final String placeholderText;
  final ListController<Item> listController;
  final bool isReorderable;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;
  final int initialSortIndex;
  final bool shouldInsertOnTop;
  final List<ListFilterItem<Item>> listFilters;
  final List<ListFilterCustomAction<Item>> customActions;
  final List<ListSortOption<Item>> sortOptions;
  final Function(int index)? onChangeSortIndex;
  final Widget? header;
  final bool isSelectable;

  @override
  State<CustomListView> createState() => _CustomListViewState<Item>();
}

class _CustomListViewState<Item extends ListItem>
    extends State<CustomListView<Item>> {
  late List<Item> currentList = List.from(widget.items);
  double _itemCardHeight = 0;
  final _scrollController = ScrollController();
  final _controller = AnimatedListController();
  late int _selectedSortIndex = widget.initialSortIndex;
  late Setting _longPressActionSetting;
  List<int> _selectedIds = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();

    _longPressActionSetting = appSettings
        .getGroup("General")
        .getGroup("Interactions")
        .getSetting("Long Press Action");

    _longPressActionSetting.addListener(_handleUpdateSettings);

    widget.listController.setChangeItems(_handleChangeItems);
    widget.listController.setAddItem(_handleAddItem);
    widget.listController.setDeleteItem(_handleDeleteItem);
    widget.listController.setGetItemIndex(_getItemIndex);
    widget.listController.setDuplicateItem(_handleDuplicateItem);
    widget.listController.setReloadItems(_handleReloadItems);
    widget.listController.setClearItems(_handleClear);
    widget.listController.setGetItems(() => widget.items);
    _updateCurrentList();
    // widget.listController.setChangeItemWithId(_handleChangeItemWithId);
  }

  @override
  void dispose() {
    _longPressActionSetting.removeListener(_handleUpdateSettings);
    super.dispose();
  }

  void _handleUpdateSettings(dynamic value) {
    setState(() {});
  }

  void _handleReloadItems(List<Item> items) {
    setState(() {
      widget.items.clear();
      widget.items.addAll(items);

      _updateCurrentList();
    });
    // TODO: MAN THIS SUCKS, WHY YOU GOTTA DO THIS
    _controller.notifyRemovedRange(
        0, widget.items.length - 1, _getChangeListBuilder());
    _controller.notifyInsertedRange(0, widget.items.length);
  }

  void _updateCurrentList() {
    if (_selectedSortIndex > widget.sortOptions.length) {
      _selectedSortIndex = 0;
    }
    currentList.clear();
    if (_selectedSortIndex != 0) {
      final temp = [...widget.items];
      temp.sort(widget.sortOptions[_selectedSortIndex - 1].sortFunction);
      currentList.addAll(temp);
    } else {
      currentList.addAll(widget.items);
    }
  }

  int _getItemIndex(Item item) =>
      currentList.indexWhere((element) => element.id == item.id);

  void _updateItemHeight() {
    if (_itemCardHeight == 0) {
      _itemCardHeight = _controller.computeItemBox(0)?.height ?? 0;
    }
  }

  void _notifyChangeList() {
    _controller.notifyChangedRange(
      0,
      currentList.length,
      _getChangeListBuilder(),
    );
  }

  ItemCardBuilder _getChangeWidgetBuilder(Item item) {
    _updateItemHeight();
    return (context, index, data) => data.measuring
        ? SizedBox(height: _itemCardHeight)
        : ListItemCard<Item>(
            key: ValueKey(item),
            onTap: () {},
            onDelete: () {},
            onDuplicate: () {},
            child: widget.itemBuilder(item),
          );
  }

  ItemCardBuilder _getChangeListBuilder() => (context, index, data) =>
      _getChangeWidgetBuilder(widget.items[index])(context, index, data);

  bool _handleReorderItems(int oldIndex, int newIndex, Object? slot) {
    if (newIndex >= widget.items.length || _selectedSortIndex != 0)
      return false;
    widget.onReorderItem?.call(widget.items[oldIndex]);
    widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
    _updateCurrentList();
    widget.onModifyList?.call();

    return true;
  }

  void _handleChangeItems(
      ItemChangerCallback<Item> callback, bool callOnModifyList) {
    final initialList = List.from(currentList);

    callback(widget.items);

    setState(() {
      _updateCurrentList();
    });

    final deletedItems = List.from(initialList
        .where(
            (element) => currentList.where((e) => e.id == element.id).isEmpty)
        .toList());
    final addedItems = List.from(currentList
        .where(
            (element) => initialList.where((e) => e.id == element.id).isEmpty)
        .toList());

    for (var deletedItem in deletedItems) {
      _controller.notifyRemovedRange(
        initialList.indexWhere((element) => element.id == deletedItem.id),
        1,
        _getChangeWidgetBuilder(deletedItem),
      );
    }

    for (var addedItem in addedItems) {
      _controller.notifyInsertedRange(
        currentList.indexWhere((element) => element.id == addedItem.id),
        1,
      );
    }

    _notifyChangeList();

    if (callOnModifyList) widget.onModifyList?.call();
  }

  Future<void> _handleDeleteItem(Item deletedItem,
      [bool callOnModifyList = true]) async {
    int index = _getItemIndex(deletedItem);

    // print(listToString(widget.items));

    setState(() {
      widget.items.removeWhere((element) => element.id == deletedItem.id);
      _updateCurrentList();
    });

    _controller.notifyRemovedRange(
      index,
      1,
      _getChangeWidgetBuilder(deletedItem),
    );
    await widget.onDeleteItem?.call(deletedItem);
    if (callOnModifyList) widget.onModifyList?.call();
  }

  Future<void> _handleDeleteItemList(List<Item> deletedItems) async {
    for (var item in deletedItems) {
      int index = _getItemIndex(item);

      setState(() {
        widget.items.removeWhere((element) => element.id == item.id);
        _updateCurrentList();
      });

      _controller.notifyRemovedRange(
        index,
        1,
        _getChangeWidgetBuilder(deletedItems.first),
      );
    }
    for (var item in deletedItems) {
      await widget.onDeleteItem?.call(item);
    }

    widget.onModifyList?.call();
  }

  void _handleClear() {
    _handleDeleteItemList(List<Item>.from(widget.items));
  }

  Future<void> _handleAddItem(Item item, {int index = -1}) async {
    if (index == -1) {
      index = widget.shouldInsertOnTop ? 0 : widget.items.length;
    }
    widget.items.insert(index, item);
    await widget.onAddItem?.call(item);
    setState(() {
      _updateCurrentList();
    });

    int currentListIndex = _getItemIndex(item);
    _controller.notifyInsertedRange(currentListIndex, 1);
    // _scrollToIndex(index);
    // TODO: Remove this delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToIndex(currentListIndex);
    });
    _updateItemHeight();
    widget.onModifyList?.call();
  }

  void _handleDuplicateItem(Item item) {
    _handleAddItem(item.copy(), index: _getItemIndex(item) + 1);
  }

  void _scrollToIndex(int index) {
    // if (_scrollController.offset == 0) {
    //   _scrollController.jumpTo(1);
    // }
    if (_itemCardHeight == 0 && index != 0) return;
    _scrollController.animateTo(index * _itemCardHeight,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  void _endSelection() {
    setState(() {
      _isSelecting = false;
      _selectedIds.clear();
    });
    _notifyChangeList();
  }

  void _startSelection(Item item) {
    setState(() {
      _isSelecting = true;
      _selectedIds = [item.id];
    });
    _notifyChangeList();
  }

  void _handleSelect(Item item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        _selectedIds.add(item.id);
      }
    });
    if (_selectedIds.isEmpty) {
      _endSelection();
    }
    _notifyChangeList();
  }

  void _handleSelectAll() {
    setState(() {
      _selectedIds = widget.items.map((e) => e.id).toList();
    });
    _notifyChangeList();
  }

  _getItemBuilder() {
    return (BuildContext context, Item item, data) {
      for (var filter in widget.listFilters) {
        // print("${filter.displayName} ${filter.filterFunction}");
        if (!filter.filterFunction(item)) {
          return Container();
        }
      }
      int index = _getItemIndex(item);
      var itemWidget = data.measuring
          ? SizedBox(height: _itemCardHeight)
          : ListItemCard<Item>(
              key: ValueKey(item),
              onTap: () {
                return widget.onTapItem?.call(item, index);
              },
              onDelete:
                  widget.isDeleteEnabled ? () => _handleDeleteItem(item) : null,
              onDuplicate: () => _handleDuplicateItem(item),
              isDeleteEnabled: item.isDeletable && widget.isDeleteEnabled,
              isDuplicateEnabled: widget.isDuplicateEnabled,
              isSelected: _selectedIds.contains(item.id),
              child: widget.itemBuilder(item),
            );
      if (widget.isSelectable &&
          _longPressActionSetting.value == LongPressAction.multiSelect) {
        itemWidget = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () {
            if (!_isSelecting) {
              _startSelection(item);
            } else {
              _handleSelect(item);
            }
          },
          onTap: () {
            if (_isSelecting) {
              _handleSelect(item);
            }
          },
          child: AbsorbPointer(absorbing: _isSelecting, child: itemWidget),
        );
      }
      return itemWidget;
    };
  }

  void _onFilterChange() {
    setState(() {
      _notifyChangeList();
    });
  }

  List<Item> _getCurrentList() {
    final List<Item> items = List.from(widget.items);

    if (_selectedSortIndex != 0) {
      items.sort(widget.sortOptions[_selectedSortIndex - 1].sortFunction);
    }

    return items;
  }

  List<Item> _getActionableItems() {
    return _isSelecting
        ? widget.items.where((item) => _selectedIds.contains(item.id)).toList()
        : widget.items;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    final isReorderable =
        _longPressActionSetting.value == LongPressAction.reorder &&
            widget.isReorderable;

    if (_selectedSortIndex > widget.sortOptions.length) {
      _updateCurrentList();
    }

    List<Widget> getFilterChips() {
      List<Widget> widgets = [];
      int activeFilterCount =
          widget.listFilters.where((filter) => filter.isActive).length;
      if (activeFilterCount > 0 || _isSelecting) {
        widgets.add(
          ListFilterActionChip(
            actions: [
              ListFilterAction(
                name: AppLocalizations.of(context)!.clearFiltersAction,
                icon: Icons.clear_rounded,
                action: () {
                  for (var filter in widget.listFilters) {
                    filter.reset();
                  }
                  _endSelection();
                  _onFilterChange();
                },
              ),
              ...widget.customActions.map((action) => ListFilterAction(
                    name: action.name,
                    icon: action.icon,
                    action: () {
                      final list = _getActionableItems();

                      action.action(list
                          .where((item) => widget.listFilters
                              .every((filter) => filter.filterFunction(item)))
                          .toList());
                      _endSelection();
                    },
                  )),
              ListFilterAction(
                name: AppLocalizations.of(context)!.deleteAllFilteredAction,
                icon: Icons.delete_rounded,
                color: colorScheme.error,
                action: () async {
                  Navigator.pop(context);
                  final result = await showDeleteAlertDialogue(context);
                  if (result == null || result == false) return;

                  final list = _getActionableItems();
                  final toRemove = List<Item>.from(list.where((item) => widget
                      .listFilters
                      .every((filter) => filter.filterFunction(item))));
                  _endSelection();
                  await _handleDeleteItemList(toRemove);

                  widget.onModifyList?.call();
                },
              )
            ],
            activeFilterCount: activeFilterCount + (_isSelecting ? 1 : 0),
          ),
        );
      }
      if (_isSelecting) {
        widgets.add(
          ListButtonChip(
            label: AppLocalizations.of(context)!
                .selectionStatus(_selectedIds.length),
            icon: Icons.clear_rounded,
            onTap: _endSelection,
          ),
        );
        widgets.add(
          ListButtonChip(
            label: AppLocalizations.of(context)!.selectAll,
            icon: Icons.select_all,
            onTap: _handleSelectAll,
          ),
        );
      }
      widgets.addAll(widget.listFilters
          .map((filter) => getListFilterChip(filter, _onFilterChange)));
      if (widget.sortOptions.isNotEmpty) {
        widgets.add(
          ListSortChip(
            selectedIndex: _selectedSortIndex,
            sortOptions: [
              ListSortOption(
                  (context) => AppLocalizations.of(context)!.defaultLabel,
                  (a, b) => 0),
              ...widget.sortOptions,
            ],
            onChange: (index) => setState(() {
              _selectedSortIndex = index;
              widget.onChangeSortIndex?.call(index);
              _updateCurrentList();
              _notifyChangeList();
            }),
          ),
        );
      }
      return widgets;
    }

    // timeDilation = 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: getFilterChips(),
              ),
            ),
          ),
        ),
        if (widget.header != null) widget.header!,
        Expanded(
          flex: 1,
          child: Stack(children: [
            widget.items.isEmpty
                ? SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        widget.placeholderText,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6),
                                ),
                      ),
                    ),
                  )
                : Container(),
            SlidableAutoCloseBehavior(
              child: AutomaticAnimatedListView<Item>(
                list: currentList,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                comparator: AnimatedListDiffListComparator<Item>(
                  sameItem: (a, b) => a.id == b.id,
                  sameContent: (a, b) => a.id == b.id,
                ),
                itemBuilder: _getItemBuilder(),
                // animator: DefaultAnimatedListAnimator,
                listController: _controller,
                scrollController: _scrollController,
                addLongPressReorderable: isReorderable,
                reorderModel: isReorderable && _selectedSortIndex == 0
                    ? AnimatedListReorderModel(
                        onReorderStart: (index, dx, dy) => true,
                        onReorderFeedback: (int index, int dropIndex,
                                double offset, double dx, double dy) =>
                            null,
                        onReorderMove: (int index, int dropIndex) => true,
                        onReorderComplete: _handleReorderItems,
                      )
                    : null,
                reorderDecorationBuilder:
                    isReorderable ? reorderableListDecorator : null,
                footer: const SizedBox(height: 64 + 80),
                // header: widget.header,

                // cacheExtent: double.infinity,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
