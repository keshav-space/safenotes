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

// Dart imports:
import 'dart:async';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:workmanager/workmanager.dart';

// Project imports:
import 'package:safenotes/app.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/generic.dart';
import 'package:safenotes/dialogs/logout_alert.dart';
import 'package:safenotes/models/editor_state.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/sheduled_task.dart';
import 'package:safenotes/views/settings/backup_setting.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await PreferencesStorage.init();
  if (Platform.isAndroid && PreferencesStorage.isFlagSecure)
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    if (PreferencesStorage.isAutoRotate) ...[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]
  ]);

  onAppUpdate();

  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: SafeNotesConfig.localesValues,
      fallbackLocale: Locale('en', 'US'),
      child: SafeNotesApp(),
    ),
  );
}

class SafeNotesApp extends StatelessWidget {
  SafeNotesApp({Key? key}) : super(key: key);

  final navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => navigatorKey.currentState;
  final sessionStateStream = StreamController<SessionState>();
  final int foucsTimeout = PreferencesStorage.focusTimeout;
  final int inactivityTimeout = PreferencesStorage.inactivityTimeout;

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: Duration(seconds: foucsTimeout),
      invalidateSessionForUserInactiviity: Duration(seconds: inactivityTimeout),
    );

    sessionConfig.stream.listen(sessionHandler);
    //  stop listening, as user will already be in auth page
    sessionStateStream.add(SessionState.stopListening);

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: App(
        sessionStateStream: sessionStateStream,
        navigatorKey: navigatorKey,
      ),
    );
  }

  Future<void> sessionHandler(SessionTimeoutState timeoutEvent) async {
    // stop listening, as user will already be in auth page
    sessionStateStream.add(SessionState.stopListening);
    BuildContext context = navigatorKey.currentContext!;

    if (timeoutEvent == SessionTimeoutState.userInactivityTimeout &&
        PreferencesStorage.isInactivityTimeoutOn) {
      await onTimeOutDo(
        context: context,
        showPreLogoffAlert: true,
      );
      // Don't logout if user is active
    } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
      await onTimeOutDo(
        context: context,
        showPreLogoffAlert: false,
      );
    }
  }

  Future<void> onTimeOutDo(
      {required BuildContext context, required bool showPreLogoffAlert}) async {
    // execute only if user is already logged
    // no need to logout and redirect to authwall if user is not loggedIN
    if (PhraseHandler.getPass.isNotEmpty) {
      bool? isUserActive;
      if (showPreLogoffAlert)
        isUserActive = await preInactivityLogOffAlert(context);
      if (isUserActive == null || showPreLogoffAlert == false) {
        // isUserActive == null => show him logout Msg
        // showPreLogoffAlert == false => i.e. triggered by appFocusTimeout
        logout(
          context: context,
          showLogoutMsg: true,
        );
      }
      if (isUserActive == false) {
        // isUserActive == false => user choose to logout, don't show msg
        logout(
          context: context,
          showLogoutMsg: false,
        );
      }
      //else user pressed cancel and is active
    }
    // User is already on authpage
  }

  Future<void> logout({
    required BuildContext context,
    required bool showLogoutMsg,
  }) async {
    _navigator?.pushNamedAndRemoveUntil(
      '/authwall',
      (Route<dynamic> route) => false,
      arguments: SessionArguments(
        sessionStream: sessionStateStream,
        isKeyboardFocused: false,
      ),
    );

    if (showLogoutMsg)
      showGenericDialog(
        context: context,
        icon: Icons.info_outline,
        message:
            "You were logged out due to extended inactivity. This is to protect your privacy."
                .tr(),
      );

    // save unsaved note if any
    await NoteEditorState().handleUngracefulNoteExit();
    Session.logout();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await ScheduledTask.backup();
    return Future.value(true);
  });
}

// run once every update
void onAppUpdate() async {
  if (PreferencesStorage.appVersionCode != SafeNotesConfig.appVersionCode) {
    // Re-register the background update

    if (PreferencesStorage.isBackupOn) {
      if (await handleBackupPermissionAndLocation()) {
        backupRegister();
        await ScheduledTask.backup();
      }
    }

    // insure onAppUpdate is run once each update
    PreferencesStorage.setAppVersionCodeToCurrent();
  }
}
