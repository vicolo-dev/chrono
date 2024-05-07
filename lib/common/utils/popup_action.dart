import 'package:clock_app/common/types/popup_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


PopupAction getDeletePopupAction(BuildContext context, Function callback) {
  return PopupAction(AppLocalizations.of(context)!.deleteButton, callback, Icons.delete_rounded,
      Theme.of(context).colorScheme.error);
}

PopupAction getDuplicatePopupAction(BuildContext context, Function callback) {
  return PopupAction(AppLocalizations.of(context)!.duplicateButton, callback, Icons.copy_rounded);
}
