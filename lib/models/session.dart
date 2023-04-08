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
import 'dart:convert';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/biometric_auth.dart';

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
    if (PreferencesStorage.isBiometricAuthEnabled) BiometricAuth.setAuthKey();
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
