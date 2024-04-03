import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:flutter/material.dart';

class PersistentListController<T> {
  VoidCallback? _onReload;
  final ListController<T> _listController = ListController<T>();

  ListController<T> get listController => _listController;

  PersistentListController();

  void setOnReload(VoidCallback onReload) {
    _onReload = onReload;
  }

  void changeItems(ItemChangerCallback<T> callback,
      {bool callOnModifyList = true}) {
    _listController.changeItems(callback, callOnModifyList: callOnModifyList);
  }

  void addItem(T item) {
    _listController.addItem(item);
  }

  void duplicateItem(T item) {
    _listController.duplicateItem(item);
  }

  void deleteItem(T item) {
    _listController.deleteItem(item);
  }

  void clearItems() {
    _listController.clearItems();
  }

  int getItemIndex(T item) {
    return _listController.getItemIndex(item);
  }

  void reloadItems(List<T> items) {
    _listController.reload(items);
  }

  void reload() {
    _onReload?.call();
  }
}

class PersistentListView<Item extends ListItem> extends StatefulWidget {
  const PersistentListView({
    super.key,
    required this.itemBuilder,
    required this.saveTag,
    required this.listController,
    this.onTapItem,
    this.onReorderItem,
    this.onDeleteItem,
    this.onAddItem,
    this.placeholderText = '',
    this.isReorderable = true,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
    this.reloadOnPop = false,
    this.shouldInsertOnTop = true,
    this.listFilters = const [],
  });

  final Widget Function(Item item) itemBuilder;
  final void Function(Item item, int index)? onTapItem;
  final void Function(Item item)? onReorderItem;
  final void Function(Item item)? onDeleteItem;
  final void Function(Item item)? onAddItem;
  final String saveTag;
  final String placeholderText;
  final PersistentListController<Item> listController;
  final bool isReorderable;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;
  final bool reloadOnPop;
  final bool shouldInsertOnTop;
  final List<ListFilterItem<Item>> listFilters;

  @override
  State<PersistentListView> createState() => _PersistentListViewState<Item>();
}

class _PersistentListViewState<Item extends ListItem>
    extends State<PersistentListView<Item>> {
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    widget.listController.setOnReload(loadItems);
    if (widget.saveTag.isNotEmpty) {
      _items = loadListSync<Item>(widget.saveTag);
    }
    // watchList(widget.saveTag, (event) => reloadItems());
    ListenerManager.addOnChangeListener(widget.saveTag, loadItems);
    // ListenerManager.addOnChangeListener(
    //     "${widget.saveTag}-reload", reloadItems);
  }

  @override
  void dispose() {
    ListenerManager.removeOnChangeListener(widget.saveTag, loadItems);
    // ListenerManager.removeOnChangeListener(
    //     "${widget.saveTag}-reload", loadItems);
    // unwatchList(widget.saveTag);
    super.dispose();
  }

  void reloadItems() {
    List<Item> newList = loadListSync<Item>(widget.saveTag);
    widget.listController.reloadItems(newList);
  }

  void loadItems() {
    if (widget.saveTag.isNotEmpty) {
      widget.listController.changeItems(
        (List<Item> items) {
          List<Item> newList = loadListSync<Item>(widget.saveTag);
          items.clear();
          items.addAll(newList);
/*           print("--------------------------------------------- ${listToString(items)}"); */
        },
        callOnModifyList: false,
      );
    }
  }

  void saveItems() {
    if (widget.saveTag.isNotEmpty) {
      saveList<Item>(widget.saveTag, _items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomListView<Item>(
      items: _items,
      itemBuilder: widget.itemBuilder,
      onTapItem: widget.onTapItem,
      onReorderItem: widget.onReorderItem,
      onDeleteItem: widget.onDeleteItem,
      onAddItem: widget.onAddItem,
      listController: widget.listController.listController,
      placeholderText: widget.placeholderText,
      onModifyList: saveItems,
      isReorderable: widget.isReorderable,
      isDeleteEnabled: widget.isDeleteEnabled,
      isDuplicateEnabled: widget.isDuplicateEnabled,
      shouldInsertOnTop: widget.shouldInsertOnTop,
      listFilters: widget.listFilters,
    );
  }
}
