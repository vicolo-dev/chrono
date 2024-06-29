import 'package:logger/logger.dart';

var logger = Logger();

logDebug(String message) {
  logger.d(message);
}

logError(String message, String error) {
  logger.e(message, error: error);
}

logInfo(String message) {
  logger.i(message);
}

logTrace(String message) {
  logger.t(message);
}

logWarning(String message) {
  logger.w(message);
}
