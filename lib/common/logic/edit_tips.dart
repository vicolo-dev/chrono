// Show user that sliding alarm card can be used to edit alarm or timer
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future<void> showEditTip(context) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  var slidable = Slidable.of(context);

  slidable?.openEndActionPane(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );

  await Future.delayed(const Duration(milliseconds: 500), () {
    slidable?.close(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  });

  await Future.delayed(const Duration(milliseconds: 200), () {
    slidable?.openStartActionPane(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  });

  Future.delayed(const Duration(milliseconds: 500), () {
    slidable?.close(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
}
