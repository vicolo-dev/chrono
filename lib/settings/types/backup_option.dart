import 'package:flutter/material.dart';

class BackupOption {
  final String Function(BuildContext context) getName;
  final String key;
  final dynamic Function() encode;
  final Function(BuildContext context, dynamic value) decode;
  bool selected = true;

  BackupOption(this.key, this.getName,
      {required this.encode, required this.decode});
}


