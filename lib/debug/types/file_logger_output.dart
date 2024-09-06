import 'dart:io';

import 'package:clock_app/common/data/paths.dart';
import 'package:logger/logger.dart';



class FileLoggerOutput extends LogOutput {
  FileLoggerOutput();

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      print(line);
    }

    _writeLog(event.origin.message as String);
  }

  Future<void> _writeLog(String message) async {
    final DateTime currentDate = DateTime.now();
    final String dateString =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    final File file = File(await getLogsFilePath());

    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    file.writeAsStringSync(
      "[$dateString | ${currentDate.hour}:${currentDate.minute}:${currentDate.second}] $message\n",
      mode: FileMode.append,
    );
  }
}
