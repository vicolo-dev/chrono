import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/list/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:great_list_view/great_list_view.dart';

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
    this.duplicateItem,
    this.onTapItem,
    this.onReorderItem,
    this.onDeleteItem,
    this.onAddItem,
    this.placeholderText = '',
    this.onModifyList,
    this.isReorderable = true,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
  });

  final List<Item> items;
  final Widget Function(Item item) itemBuilder;
  final Item Function(Item item)? duplicateItem;
  final void Function(Item item, int index)? onTapItem;
  final void Function(Item item)? onReorderItem;
  final void Function(Item item)? onDeleteItem;
  final void Function(Item item)? onAddItem;
  final void Function()? onModifyList;
  final String placeholderText;
  final ListController<Item> listController;
  final bool isReorderable;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;

  @override
  State<CustomListView> createState() => _CustomListViewState<Item>();
}

class _CustomListViewState<Item extends ListItem>
    extends State<CustomListView<Item>> {
  double _itemCardHeight = 0;
  late int lastListLength = widget.items.length;
  final _scrollController = ScrollController();
  final _controller = AnimatedListController();

  @override
  void initState() {
    super.initState();
    widget.listController.setChangeItems(_changeItems);
    widget.listController.setAddItem(_handleAddItem);
    widget.listController.setGetItemIndex(_getItemIndex);
  }

  int _getItemIndex(Item item) =>
      widget.items.indexWhere((element) => element.id == item.id);

  void _updateItemHeight() {
    if (_itemCardHeight == 0) {
      _itemCardHeight = _controller.computeItemBox(0)?.height ?? 0;
    }
  }

  void _changeItems(ItemChangerCallback<Item> callback, bool callOnModifyList) {
    setState(() {
      callback(widget.items);
    });
    _notifyChangeList();

    if (callOnModifyList) widget.onModifyList?.call();
  }

  void _notifyChangeList() {
    _controller.notifyChangedRange(
      0,
      widget.items.length,
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
    if (newIndex >= widget.items.length) return false;
    widget.onReorderItem?.call(widget.items[oldIndex]);
    widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
    widget.onModifyList?.call();

    return true;
  }

  _handleDeleteItem(Item deletedItem) {
    widget.onDeleteItem?.call(deletedItem);

    int index = _getItemIndex(deletedItem);
    setState(() {
      widget.items.removeAt(index);
    });

    _controller.notifyRemovedRange(
      index,
      1,
      _getChangeWidgetBuilder(deletedItem),
    );
    widget.onModifyList?.call();
    lastListLength = widget.items.length;
  }

  Stopwatch stopwatch = Stopwatch();

  void _handleAddItem(Item item, {int index = -1}) {
    widget.onAddItem?.call(item);

    if (index == -1) index = 0;
    setState(() => widget.items.insert(index, item));
    _controller.notifyInsertedRange(index, 1);
    stopwatch.start();
    _scrollToIndex(index);
    Future.delayed(const Duration(milliseconds: 250), () {
      _scrollToIndex(index);
    });
    _updateItemHeight();
    widget.onModifyList?.call();
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(index * _itemCardHeight,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.75;
    return Stack(children: [
      widget.items.isEmpty
          ? SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Text(
                  widget.placeholderText,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
          list: widget.items,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          comparator: AnimatedListDiffListComparator<Item>(
            sameItem: (a, b) => a.id == b.id,
            sameContent: (a, b) => a.id == b.id,
          ),
          itemBuilder: (BuildContext context, Item item, data) {
            return data.measuring
                ? SizedBox(height: _itemCardHeight)
                : ListItemCard<Item>(
                    key: ValueKey(item),
                    onTap: () {
                      return widget.onTapItem?.call(item, _getItemIndex(item));
                    },
                    onDelete: widget.isDeleteEnabled
                        ? () => _handleDeleteItem(item)
                        : null,
                    onDuplicate: widget.duplicateItem != null
                        ? () => _handleAddItem(widget.duplicateItem!(item),
                            index: _getItemIndex(item) + 1)
                        : null,
                    onInit: () {
                      // if (_getItemIndex(item) == 0 &&
                      //     widget.items.length > lastListLength) {
                      //   lastListLength = widget.items.length;
                      //   _scrollToIndex(0);
                      // }
                      // print(stopwatch.elapsedMilliseconds);
                      // stopwatch.stop();
                      // stopwatch.reset();
                    },
                    isDeleteEnabled: widget.isDeleteEnabled,
                    isDuplicateEnabled: widget.isDuplicateEnabled,
                    child: widget.itemBuilder(item),
                  );
          },
          // animator: DefaultAnimatedListAnimator,
          listController: _controller,
          scrollController: _scrollController,
          addLongPressReorderable: widget.isReorderable,
          reorderModel: widget.isReorderable
              ? AnimatedListReorderModel(
                  onReorderStart: (index, dx, dy) => true,
                  onReorderFeedback: (int index, int dropIndex, double offset,
                          double dx, double dy) =>
                      null,
                  onReorderMove: (int index, int dropIndex) => true,
                  onReorderComplete: _handleReorderItems,
                )
              : null,
          reorderDecorationBuilder:
              widget.isReorderable ? reorderableListDecorator : null,
          footer: const SizedBox(height: 64),
          // cacheExtent: double.infinity,
        ),
      ),
    ]);
  }
}
