typedef ItemChangerCallback<T> = void Function(List<T> item);
typedef ItemChanger<T> = void Function(ItemChangerCallback<T>, bool);

class ListController<T> {
  ItemChanger<T>? _changeItems;
  void Function(T item)? _addItem;
  void Function(T item)? _deleteItem;
  int Function(T item)? _getItemIndex;

  ListController();

  void setChangeItems(ItemChanger<T> changeItems) {
    _changeItems = changeItems;
  }

  void changeItems(ItemChangerCallback<T> callback,
      {bool callOnModifyList = true}) {
    _changeItems?.call(callback, callOnModifyList);
  }

  void setGetItemIndex(int Function(T item) callback) {
    _getItemIndex = callback;
  }

  void setAddItem(void Function(T item) callback) {
    _addItem = callback;
  }

  void setDeleteItem(void Function(T item) callback) {
    _deleteItem = callback;
  }

  void addItem(T item) {
    _addItem?.call(item);
  }

  void deleteItem(T item) {
    _deleteItem?.call(item);
  }

  int getItemIndex(T item) {
    return _getItemIndex?.call(item) ?? 0;
  }
}
