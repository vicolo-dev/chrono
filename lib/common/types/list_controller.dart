typedef ItemChangerCallback<T> = void Function(List<T> items);
typedef ItemChanger<T> = void Function(ItemChangerCallback<T>, bool);

class ListController<T> {
  ItemChanger<T>? _changeItems;
  void Function(T item)? _addItem;
  int Function(T item)? _getItemIndex;

  ListController();

  void setChangeItem(ItemChanger<T> changeItems) {
    _changeItems = changeItems;
  }

  void changeItems(ItemChangerCallback<T> callback,
      {bool callOnModifyList = true}) {
    _changeItems?.call(callback, callOnModifyList);
  }

  void setGetItemIndex(int Function(T item) builder) {
    _getItemIndex = builder;
  }

  void setAddItem(void Function(T item) builder) {
    _addItem = builder;
  }

  void addItem(T item) {
    _addItem?.call(item);
  }

  int getItemIndex(T item) {
    return _getItemIndex?.call(item) ?? 0;
  }
}
