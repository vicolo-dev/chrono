import 'package:flutter/material.dart';

class BackupOption {
  final String Function(BuildContext context) getName;
  final String key;
  final Future<dynamic> Function() encode;
  final Future<void> Function(BuildContext context, dynamic value) decode;
  bool selected = true;

  BackupOption(this.key, this.getName,
      {required this.encode, required this.decode});
}
