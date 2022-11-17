import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isAndroidSdkVersionAbove(int api) async =>
    (await DeviceInfoPlugin().androidInfo).version.sdkInt > api;
