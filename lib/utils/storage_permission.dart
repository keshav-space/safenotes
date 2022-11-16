// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// return true on successful storage permission
Future<bool> handleStoragePermission() async {
  // if sdk is above 29 no permission needed to store file in Download folder
  if (!await _isAndroidSdkVersionAbove29() &&
      !await _requestPermission(Permission.storage)) return false;
  return true;
}

Future<bool> _isAndroidSdkVersionAbove29() async =>
    (await DeviceInfoPlugin().androidInfo).version.sdkInt > 29;

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var status = await permission.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }
}
