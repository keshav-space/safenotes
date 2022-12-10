// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Project imports:
import '../data/preference_and_config.dart';

class BiometricAuth {
  static const String _secureBiometricAuthKey = "_secureBiometricAuthKey";
  static final storage = FlutterSecureStorage();

  static Future<String> get authKey async {
    // await storage.write(
    //   key: _secureBiometricAuthKey,
    //   value: "android@123",
    // );

    return await storage.read(key: _secureBiometricAuthKey) ?? '';
  }

  static Future<void> setAuthKey() async {
    await storage.write(
      key: _secureBiometricAuthKey,
      value: PhraseHandler.getPass,
    );
  }

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
