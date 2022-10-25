// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class Session {
  static login(String passphrase) {
    PhraseHandler.initPass(passphrase);
  }

  static logout() {
    PhraseHandler.destroy();
  }

  static setOrChangePassphrase(String passphrase) {
    PreferencesStorage.setPassPhraseHash(
        sha256.convert(utf8.encode(passphrase)).toString());
    PhraseHandler.initPass(passphrase);
  }
}

class SessionArguments {
  final StreamController<SessionState> sessionStream;
  final bool? isKeyboardFocused;

  SessionArguments({
    required this.sessionStream,
    this.isKeyboardFocused,
  });
}
