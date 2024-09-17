import 'package:logger/logger.dart';

class FileLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
