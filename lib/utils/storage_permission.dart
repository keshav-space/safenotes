// Package imports:
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:safenotes/utils/device_info.dart';

// return true on successful storage permission
Future<bool> handleStoragePermission() async {
  // if sdk is above 29 no permission needed to store file in Download folder
  if (!await isAndroidSdkVersionAbove(29) &&
      !await _requestPermission(Permission.storage)) return false;
  return true;
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted)
    return true;
  else {
    var status = await permission.request();
    if (status.isGranted) return true;
    return false;
  }
}
