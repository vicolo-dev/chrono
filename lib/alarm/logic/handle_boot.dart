import 'dart:io';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';

@pragma('vm:entry-point')
void handleBoot() async {
  // Code to run when the function is called
  String appDataDirectory = await getAppDataDirectoryPath();

  String message = '[${DateTime.now().toString()}] Test2\n';

  // log something to a file in the app's data directory
  File('$appDataDirectory/log-dart.txt')
      .writeAsStringSync(message, mode: FileMode.append);

  print(message);
}
