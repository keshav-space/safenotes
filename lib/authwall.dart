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

  AuthWall({Key? key, required this.sessionStateStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencesStorage.getPassPhraseHash() != null
        ? EncryptionPhraseLoginPage(sessionStream: sessionStateStream)
        : SetEncryptionPhrasePage(sessionStream: sessionStateStream);
  }
}
