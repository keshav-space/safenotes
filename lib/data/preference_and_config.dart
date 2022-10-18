// Dart imports:
import 'dart:io';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorage {
  static SharedPreferences? _preferences;

  static const _keyPassPhraseHash = 'passphrasehash';
  static const _keyIsThemeDark = 'isthemedark';
  static const _keyKeyboardIncognito = 'keyboardIcognito';
  static const _keyInactivityTimeout = 'inactivityTimeout';
  static const _keyFocusTimeout = 'focusTimeout';
  static const _keyPreInactivityLogoutCounter = 'preInactivityLogoutCounter';
  static const _keyNoOfLogginAttemptAllowed = 'noOfLogginAttemptAllowed';
  static const _keyBruteforceLockOutTime = 'bruteforceLockOutTime';
  static const _keyIsColorful = 'isColorful';
  static const _keyLastBackupTime = 'lastBackupTime';
  static const _keyBackupDestination = 'backupDestination';
  static const _keyIsBackupOn = 'isBackupOn';
  static const _keyColorfulNotesColorIndex = 'colorfulNotesColorIndex';
  static const _keyIsGridView = 'isGridView';
  static const _keyIsNewFirst = 'isNewFirst';
  static const _keyIsFlagSecure = 'isFlagSecure';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> setPassPhraseHash(String passphrasehash) async =>
      await _preferences?.setString(_keyPassPhraseHash, passphrasehash);

  static String getPassPhraseHash() =>
      _preferences?.getString(_keyPassPhraseHash) ?? '';

  static int getColorfulNotesColorIndex() =>
      _preferences?.getInt(_keyColorfulNotesColorIndex) ?? 0;

  static Future<void> setColorfulNotesColorIndex(int index) async =>
      await _preferences?.setInt(_keyColorfulNotesColorIndex, index);

  static bool getIsThemeDark() =>
      _preferences?.getBool(_keyIsThemeDark) ?? true;

  static Future<void> setIsThemeDark(bool flag) async =>
      await _preferences?.setBool(_keyIsThemeDark, flag);

  static bool getIsFlagSecure() =>
      _preferences?.getBool(_keyIsFlagSecure) ?? true;

  static Future<void> setIsFlagSecure(bool flag) async =>
      await _preferences?.setBool(_keyIsFlagSecure, flag);

  static bool getIsGridView() => _preferences?.getBool(_keyIsGridView) ?? true;

  static Future<void> setIsGridView(bool flag) async =>
      await _preferences?.setBool(_keyIsGridView, flag);
  static bool getIsNewFirst() => _preferences?.getBool(_keyIsNewFirst) ?? true;

  static Future<void> setIsNewFirst(bool flag) async =>
      await _preferences?.setBool(_keyIsNewFirst, flag);

  static String getLastBackupTime() =>
      _preferences?.getString(_keyLastBackupTime) ?? '';

  static Future<void> setLastBackupTime() async => await _preferences
      ?.setString(_keyLastBackupTime, DateTime.now().toIso8601String());

  static bool getIsBackupOn() =>
      _preferences?.getBool(_keyIsBackupOn) ?? false; //true;

  static Future<void> setIsBackupOn(bool flag) async =>
      await _preferences?.setBool(_keyIsBackupOn, flag);

  static Future<String> getBackupDestination() async {
    String? path = _preferences?.getString(_keyBackupDestination);
    if (path != null && await Directory(path).exists()) return path;
    return '';
  }

  static Future<void> setBackupDestination(String path) async =>
      await _preferences?.setString(_keyBackupDestination, path);

  static bool getIsColorful() => _preferences?.getBool(_keyIsColorful) ?? true;

  static Future<void> setIsColorful(bool flag) async =>
      await _preferences?.setBool(_keyIsColorful, flag);

  static Future<void> setKeyboardIncognito(bool flag) async =>
      await _preferences?.setBool(_keyKeyboardIncognito, flag);

  static bool getKeyboardIncognito() =>
      _preferences?.getBool(_keyKeyboardIncognito) ?? true;

  static int getNoOfLogginAttemptAllowed() {
    //default: 3 unsucessful
    return _preferences?.getInt(_keyNoOfLogginAttemptAllowed) ?? 4;
  }

  static int getBruteforceLockOutTime() {
    //default: 30 seconds
    return _preferences?.getInt(_keyBruteforceLockOutTime) ?? 30;
  }

  static int getInactivityTimeout() {
    //default: 6 minutes
    /*
      index >= 0 and index < 4
    */
    var index = _preferences?.getInt(_keyInactivityTimeout);
    if (!(index != null && index >= 0 && index < 4)) index = 1; // default

    return (4 + (index * 2)) * 60;
  }

  static int getFocusTimeout() {
    //default: 5 minutes
    return _preferences?.getInt(_keyFocusTimeout) ?? 3 * 60;
  }

  static int getPreInactivityLogoutCounter() {
    //default: 30 seconds
    return _preferences?.getInt(_keyPreInactivityLogoutCounter) ?? 30;
  }

  static int getInactivityTimeoutIndex() =>
      _preferences?.getInt(_keyInactivityTimeout) ?? 1;

  static Future<void> setInactivityTimeoutIndex({required int index}) async {
    await _preferences?.setInt(_keyInactivityTimeout, index);
  }

  // static Future<void> setFocusTimeout({required int minutes}) async {
  //   await _preferences?.setInt(_keyFocusTimeout, minutes * 60);
  // }

  static Future<void> setPreInactivityLogoutCounter(
      {required int seconds}) async {
    await _preferences?.setInt(_keyPreInactivityLogoutCounter, seconds);
  }
}

class PhraseHandler {
  static String _passphrase = '';

  static initPass(String pass) => _passphrase = pass;
  static destroy() => _passphrase = '';

  static String getPass() => _passphrase;
}

class ImportEncryptionControl {
  static bool isImportEncrypted = true;
  static getIsImportEncrypted() => isImportEncrypted;
  static setIsImportEncrypted(bool flag) => isImportEncrypted = flag;
}

class ImportPassPhraseHandler {
  static String? importPassPhrase;
  static String? importPassPhraseHash;
  static getImportPassPhrase() => importPassPhrase;
  static setImportPassPhrase(String imPhrase) => importPassPhrase = imPhrase;

  static String? getImportPassPhraseHash() => importPassPhraseHash;
  static setImportPassPhraseHash(String? imPhraseHash) =>
      importPassPhraseHash = imPhraseHash;
}

class SafeNotesConfig {
  static String appName = 'Safe Notes';
  static String appSlogan = 'Heaven for your data!';
  static String firstLoginPageName = 'Set Passphrase';
  static String loginPageName = 'Login';
  static String appLogoPath = 'assets/splash_500.png';
  static String appLogoAsProfilePath =
      'assets/splash.png'; //'assets/hexa_profile.png';
  static String exportFileNamePrefix = 'safenotes_export_';
  static String exportFileNameExtension = 'json';
  static String importDialogMsg =
      'If the Notes in your import file was encrypted with diffrent passphrase then you\'ll be prompted to enter the passphrase of the device that generated this export.';
  static String exportDialogMsg =
      'Choose the destination folder where you want to store your encrypted export.';
  static String mailToForFeedback =
      'mailto:safenotes@keshav.space?subject=Help and Feedback';
  static String sourceCodeUrl = 'https://github.com/keshav-space/safenotes';
  static String bugReportUrl =
      'mailto:safenotes@keshav.space?subject=Bug Report';
  static String openSourceLicence =
      'https://github.com/keshav-space/safenotes/blob/main/LICENSE';
  static String playStorUrl =
      'https://play.google.com/store/apps/details?id=com.trisven.safenotes';
  static String githubUrl = 'https://github.com/keshav-space/safenotes';

  static String getLogoAsProfile() => appLogoAsProfilePath;
  static String getBugReportUrl() => bugReportUrl;
  static String getMailToForFeedback() => mailToForFeedback;
  static String getSourceCodeUrl() => sourceCodeUrl;
  static String getOpenSourceLicence() => openSourceLicence;
  static String getPlayStoreUrl() => playStorUrl;
  static String getGithubUrl() => githubUrl;
  static String getAppName() => appName;
  static String getAppSlogan() => appSlogan;
  static String getLoginPageName() => loginPageName;
  static String getAppLogoPath() => appLogoPath;
  static String getFirstLoginPageName() => firstLoginPageName;
  static String getImortDialogMsg() => importDialogMsg;
  static String getExportDialogMsg() => exportDialogMsg;
  static String getExportFileExtension() => exportFileNameExtension;
  static String getExportFileName() {
    var dateNow = DateTime.now()
        .toString()
        .replaceAll("-", "")
        .replaceAll(" ", "_")
        .replaceAll(":", "")
        .substring(0, 15);
    return (exportFileNamePrefix + dateNow + '.' + exportFileNameExtension);
  }
}
