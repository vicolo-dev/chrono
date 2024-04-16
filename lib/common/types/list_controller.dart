typedef ItemChangerCallback<T> = Function(List<T> items);
typedef SingleItemChangerCallback<T> = Function(T item);
typedef ItemChanger<T> = Function(ItemChangerCallback<T>, bool);
typedef SingleItemChanger<T> = Function(
    int, SingleItemChangerCallback<T>, bool);

class ListController<T> {
  ItemChanger<T>? _changeItems;
  // SingleItemChanger<T>? _changeItemWithId;
  // SingleItemChanger<T>? _changeItemAtIndex;
  void Function(T item)? _addItem;
  void Function(T item)? _deleteItem;
  void Function(T item)? _duplicateItem;
  int Function(T item)? _getItemIndex;
  void Function()? _clearItems;
  void Function(List<T>)? _reloadItems;

  ListController();

  void setChangeItems(ItemChanger<T> changeItems) {
    _changeItems = changeItems;
  }

  // void setChangeItemWithId(SingleItemChanger<T> changeItems) {
  //   _changeItemWithId = changeItems;
  // }
  //
  //  void setChangeItemAtIndex(SingleItemChanger<T> changeItems) {
  //   _changeItemAtIndex = changeItems;
  // }


  void setGetItemIndex(int Function(T item) callback) {
    _getItemIndex = callback;
  }

  void setAddItem(void Function(T item) callback) {
    _addItem = callback;
  }

  void setDuplicateItem(void Function(T item) callback) {
    _duplicateItem = callback;
  }

  void setDeleteItem(void Function(T item) callback) {
    _deleteItem = callback;
  }

  void setReloadItems(void Function(List<T>) callback) {
    _reloadItems = callback;
  }

  void setClearItems(void Function() callback) {
    _clearItems = callback;
  }

  void changeItems(ItemChangerCallback<T> callback,
      {bool callOnModifyList = true}) {
    _changeItems?.call(callback, callOnModifyList);
  }
  //
  // void changeItemWithId(int id, SingleItemChangerCallback<T> callback,
  //     {bool callOnModifyList = true}) {
  //   _changeItemWithId?.call(id, callback, callOnModifyList);
  // }
  //
  //  void changeItemAtIndex(int index, SingleItemChangerCallback<T> callback,
  //     {bool callOnModifyList = true}) {
  //   _changeItemAtIndex?.call(index, callback, callOnModifyList);
  // }


  void duplicateItem(T item) {
    _duplicateItem?.call(item);
  }

  void addItem(T item) {
    _addItem?.call(item);
  }

  void deleteItem(T item) {
    _deleteItem?.call(item);
  }

  void clearItems() {
    _clearItems?.call();
  }

  void reload(List<T> items) {
    _reloadItems?.call(items);
  }

  int getItemIndex(T item) {
    return _getItemIndex?.call(item) ?? 0;
  }
}
