// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:crypto/crypto.dart';

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
