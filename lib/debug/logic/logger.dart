import 'package:clock_app/debug/types/file_logger_output.dart';
import 'package:clock_app/debug/types/log_filter.dart';
import 'package:logger/logger.dart';
import 'dart:isolate';

var logger = Logger(
  filter: FileLogFilter(),
  output: FileLoggerOutput(),
  printer: PrettyPrinter(
    methodCount: 0, // Number of method calls to be displayed
    errorMethodCount: 8, // Number of method calls if stacktrace is provided
    lineLength: 80, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    // Should each log print contain a timestamp
    dateTimeFormat: DateTimeFormat.none,
  ),
);

void printIsolateInfo() {
  logger.i(
      "Isolate: ${Isolate.current.debugName}, id: ${Isolate.current.hashCode}");
}