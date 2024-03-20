import 'package:clock_app/common/types/popup_action.dart';
import 'package:flutter/material.dart';

PopupAction getDeletePopupAction(BuildContext context, Function callback) {
  return PopupAction("Delete", callback, Icons.delete_rounded,
      Theme.of(context).colorScheme.error);
}

PopupAction getDuplicatePopupAction(Function callback) {
  return PopupAction("Duplicate", callback, Icons.copy_rounded);
}
