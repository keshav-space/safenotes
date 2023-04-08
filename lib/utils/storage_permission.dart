/*
* Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
*
* SPDX-License-Identifier: GPL-3.0-or-later
* You may use, distribute and modify this code under the
* terms of the GPL-3.0+ license.
*
* You should have received a copy of the GNU General Public License v3.0 with
* this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
*
* See https://safenotes.dev for support or download.
*/

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
