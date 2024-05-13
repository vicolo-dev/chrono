import 'package:permission_handler/permission_handler.dart';

Future<void> requestBatteryOptimizationPermission(
    {Function? onAlreadyGranted}) async {
  var status = await Permission.ignoreBatteryOptimizations.status;
  if (!status.isGranted) {
    await Permission.ignoreBatteryOptimizations.request();
  } else {
    onAlreadyGranted?.call();
  }
}
