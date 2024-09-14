import 'dart:io';

import 'package:clock_app/app.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:logger/logger.dart';

class FileLoggerOutput extends LogOutput {
  FileLoggerOutput();

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      // ignore: avoid_print
      print(line);
    }

    String message = switch (event.origin.message.runtimeType) {
      const (String) => event.origin.message as String,
      const (Exception) => (event.origin.message as Exception).toString(),
      _ => "Unknown error",
    };

    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _writeLog(message, event.level);

      if (event.level.value >= Level.error.value &&
          App.navigatorKey.currentContext != null) {
        Future(() {
          showSnackBar(App.navigatorKey.currentContext!, message,
              error: true, navBar: false, fab: false);
        });
      }
    }
  }

  Future<void> _writeLog(String message, Level level) async {
    final DateTime currentDate = DateTime.now();
    final String dateString =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    final File file = File(await getLogsFilePath());

    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    file.writeAsStringSync(
      "[$dateString | ${currentDate.hour}:${currentDate.minute}:${currentDate.second}] [${level.name}] $message\n",
      mode: FileMode.append,
    );
  }
}
