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

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/views/authentication/login.dart';
import 'package:safenotes/views/authentication/set_passphrase.dart';

class AuthWall extends StatelessWidget {
  final StreamController<SessionState> sessionStateStream;
  final bool? isKeyboardFocused;

  AuthWall({Key? key, required this.sessionStateStream, this.isKeyboardFocused})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencesStorage.passPhraseHash.isNotEmpty
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
