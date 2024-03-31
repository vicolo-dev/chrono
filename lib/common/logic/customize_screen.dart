import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

Future<Item?> openCustomizeScreen<Item extends ListItem>(
  BuildContext context,
  Widget widget, {
  Future<void>  Function(Item newItem)? onSave,
  Future<void>  Function()? onCancel,
}) async {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  Item? item = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
  if (item == null) {
    await onCancel?.call();
  } else {
    await onSave?.call(item);
  }
  return item;
}
