import 'package:package_info_plus/package_info_plus.dart';

PackageInfo? packageInfo;

Future<void> initializePackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
}

String getAppName() {
  return '${packageInfo?.appName ?? 'Chrono'}${(packageInfo?.packageName.contains("dev") ?? false) ? " Dev" : ""}';
}
