import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

Future<Item?> openCustomizeScreen<Item extends ListItem>(
  BuildContext context,
  Widget widget, {
  void Function(Item newItem)? onSave,
  void Function()? onCancel,
}) async {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  Item? item = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
  if (item == null) {
    onCancel?.call();
  } else {
    onSave?.call(item);
  }
  return item;
}
