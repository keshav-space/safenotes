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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

// Project imports:

class BiometricAuth {
  static const String _secureBiometricAuthKey = "_secureBiometricAuthKey";
  static final storage = FlutterSecureStorage();

  static Future<String> get authKey async =>
      await storage.read(key: _secureBiometricAuthKey) ?? '';

  static Future<void> setAuthKey() async => await storage.write(
        key: _secureBiometricAuthKey,
        value: PhraseHandler.getPass,
      );

  static Future<void> disable() async {
    await PreferencesStorage.setIsBiometricAuthEnabled(false);
    // Overwrite
    await storage.write(
      key: _secureBiometricAuthKey,
      value: "BiometricAuthDisabled",
    );
    await storage.delete(key: _secureBiometricAuthKey);
  }

  static Future<void> enable() async {
    await PreferencesStorage.setIsBiometricAuthEnabled(true);
    await setAuthKey();
  }
}
