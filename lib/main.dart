// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/app.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/inactivity_msg.dart';
import 'package:safenotes/models/editor_state.dart';
import 'package:safenotes/models/session.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await PreferencesStorage.init();
  runApp(SafeNotesApp());
}

class SafeNotesApp extends StatelessWidget {
  SafeNotesApp({Key? key}) : super(key: key);

  final navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => navigatorKey.currentState;
  final sessionStateStream = StreamController<SessionState>();
  final int foucsTimeout = PreferencesStorage.getFocusTimeout();
  final int inactiviityTimeout = PreferencesStorage.getInactivityTimeout();

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: Duration(seconds: foucsTimeout),
      invalidateSessionForUserInactiviity:
          Duration(seconds: inactiviityTimeout),
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

    if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
      await onTimeOutDo();
    } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
      await onTimeOutDo();
    }
  }

  Future<void> onTimeOutDo() async {
    // execute only if user is already logged
    // no need to logout and redirect to authwall if user is not loggedIN
    if (PhraseHandler.getPass().isNotEmpty) {
      _navigator?.pushNamedAndRemoveUntil(
          '/authwall', (Route<dynamic> route) => false,
          arguments: sessionStateStream);
      showInactivityDialog(navigatorKey.currentContext!);

      // save unsaved note if any
      await NoteEditorState().handleUngracefulNoteExit();
      Session.logout();
    }
  }
}
