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

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? inactiveCallBack;
  final AsyncCallback? pausedCallBack;
  final AsyncCallback? detachedCallBack;
  final AsyncCallback? hiddenCallBack;

  AppLifecycleEventHandler({
    this.resumeCallBack,
    this.inactiveCallBack,
    this.pausedCallBack,
    this.detachedCallBack,
    this.hiddenCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _executeCallback(resumeCallBack);
        break;
      case AppLifecycleState.inactive:
        await _executeCallback(inactiveCallBack);
        break;
      case AppLifecycleState.paused:
        await _executeCallback(pausedCallBack);
        break;
      case AppLifecycleState.detached:
        await _executeCallback(detachedCallBack);
        break;
      case AppLifecycleState.hidden:
        await _executeCallback(hiddenCallBack);
        break;
    }
  }

  Future<void> _executeCallback(AsyncCallback? callback) async {
    if (callback != null) {
      await callback();
    }
  }
}
