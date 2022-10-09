// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/views/auth_views/login.dart';
import 'package:safenotes/views/auth_views/set_passphrase.dart';
import 'data/preference_and_config.dart';

class AuthWall extends StatelessWidget {
  final StreamController<SessionState> sessionStateStream;
  final bool? isKeyboardFocused;

  AuthWall({Key? key, required this.sessionStateStream, this.isKeyboardFocused})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencesStorage.getPassPhraseHash().isNotEmpty
        ? EncryptionPhraseLoginPage(
            sessionStream: sessionStateStream,
            isKeyboardFocused: this.isKeyboardFocused,
          )
        : SetEncryptionPhrasePage(
            sessionStream: sessionStateStream,
            isKeyboardFocused: this.isKeyboardFocused,
          );
  }
}
