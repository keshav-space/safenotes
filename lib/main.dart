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

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: App(
        sessionStateStream: sessionStateStream,
        navigatorKey: navigatorKey,
      ),
    );
  }

  void sessionHandler(SessionTimeoutState timeoutEvent) {
    // stop listening, as user will already be in auth page
    sessionStateStream.add(SessionState.stopListening);

    if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
      PhraseHandler.destroy();
      _navigator?.pushNamedAndRemoveUntil(
          '/authwall', (Route<dynamic> route) => false,
          arguments: sessionStateStream);
    } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
      PhraseHandler.destroy();
      _navigator?.pushNamedAndRemoveUntil(
          '/authwall', (Route<dynamic> route) => false,
          arguments: sessionStateStream);
    }
  }
}
