import 'package:device_info_plus/device_info_plus.dart';

AndroidDeviceInfo? androidInfo;

Future<void> initializeAndroidInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  androidInfo = await deviceInfo.androidInfo;
}
