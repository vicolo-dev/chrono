// Show user that sliding alarm card can be used to edit alarm or timer
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future<void> showEditTip(context, bool Function() isMounted) async {
  if (!isMounted()) return;
  await Future<void>.delayed(const Duration(milliseconds: 500));
  var slidable = Slidable.of(context);

  if (!isMounted()) {
    slidable?.dispose();
    return;
  }

  slidable?.openEndActionPane(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
  if (!isMounted()) {
    slidable?.dispose();
    return;
  }

  await Future.delayed(const Duration(milliseconds: 500), () {
    if (!isMounted()) {
      slidable?.dispose();
      return;
    }

    slidable?.close(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  });

  if (!isMounted()) {
    slidable?.dispose();
    return;
  }

  await Future.delayed(const Duration(milliseconds: 200), () {
    if (!isMounted()) {
      slidable?.dispose();
      return;
    }

    slidable?.openStartActionPane(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  });
  if (!isMounted()) {
    slidable?.dispose();
    return;
  }

  Future.delayed(const Duration(milliseconds: 500), () {
    if (!isMounted()) {
      slidable?.dispose();
      return;
    }

    slidable?.close(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
}
