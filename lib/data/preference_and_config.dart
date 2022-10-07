// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorage {
  static SharedPreferences? _preferences;

  static const _keyPassPhraseHash = 'passphrasehash';
  static const _keyAllowUndecryptLoginFlag = 'undecryptLoginFlag';
  static const _keyIsThemeDark = 'isthemedark';
  static const _keyKeyboardIncognito = 'keyboardIcognito';
  static const _keyInactivityTimeout = 'inactivityTimeout';
  static const _keyFocusTimeout = 'focusTimeout';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> setPassPhraseHash(String passphrasehash) async =>
      await _preferences?.setString(_keyPassPhraseHash, passphrasehash);
  static String? getPassPhraseHash() =>
      _preferences?.getString(_keyPassPhraseHash);

  static Future<void> setAllowUndecryptLoginFlag(bool flag) async =>
      await _preferences?.setBool(_keyAllowUndecryptLoginFlag, flag);
  static bool getAllowUndecryptLoginFlag() {
    return _preferences?.getBool(_keyAllowUndecryptLoginFlag) ?? true;
  }

  static Future<void> setIsThemeDark(bool flag) async =>
      await _preferences?.setBool(_keyIsThemeDark, flag);

  static bool getIsThemeDark() {
    return _preferences?.getBool(_keyIsThemeDark) ?? true;
  }

  static Future<void> setKeyboardIncognito(bool flag) async =>
      await _preferences?.setBool(_keyKeyboardIncognito, flag);

  static bool getKeyboardIncognito() {
    return _preferences?.getBool(_keyKeyboardIncognito) ?? true;
  }

  static int getInactivityTimeout() {
    //default: 7 minutes
    return _preferences?.getInt(_keyInactivityTimeout) ?? 7 * 60;
  }

  static int getFocusTimeout() {
    //default: 5 minutes
    return _preferences?.getInt(_keyFocusTimeout) ?? 5 * 60;
  }

  static Future<void> setInactivityTimeout(int minutes) async {
    await _preferences?.setInt(_keyInactivityTimeout, minutes * 60);
  }

  static Future<void> setFocusTimeout(int minutes) async {
    await _preferences?.setInt(_keyInactivityTimeout, minutes * 60);
  }
}

class PhraseHandler {
  static String _passphrase = '';

  static initPass(String pass) => _passphrase = pass;
  static destroy() => _passphrase = '';

  static String getPass() => _passphrase;
}

class UnDecryptedLoginControl {
  static getAllowLogUnDecrypted() =>
      PreferencesStorage.getAllowUndecryptLoginFlag();

  static bool noDecryptionFlag = false;
  static setNoDecryptionFlag(bool flag) => noDecryptionFlag = flag;
  static getNoDecryptionFlag() => noDecryptionFlag;
}

class ExportEncryptionControl {
  static bool isExportEncrypted = true;
  static getIsExportEncrypted() => isExportEncrypted;
  static setIsExportEncrypted(bool flag) => isExportEncrypted = flag;
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
  static String firstLoginPageName = 'Set Encryption Phrase';
  static String loginPageName = 'Login';
  static String undecryptedLoginButtonText = 'Nah! Show Un-Decrypted';
  static String appLogoPath = 'assets/splash_500.png';
  static String appLogoAsProfilePath =
      'assets/splash.png'; //'assets/hexa_profile.png';
  static String exportFileNamePrefix = 'safenotes_export_';
  static String exportFileNameExtension = 'json';
  static String importDialogMsg =
      'If the Notes in your import file was encrypted with diffrent passphrase then you\'ll be prompted to enter the passphrase of the device that generated this export.';
  static String exportDialogMsg =
      'We recommend using the encrypted export method, this will encrypt your data using your current encryption passphrase. \nYou will be prompted to enter your passphrase while importing it.';
  static String mailToForFeedback =
      'mailto:safenotes@keshav.space?subject=Help and Feedback';
  static String sourceCodeUrl = 'https://safenotes.keshav.space';
  static String bugReportUrl =
      'mailto:safenotes@keshav.space?subject=Bug Report';

  static String getLogoAsProfile() => appLogoAsProfilePath;
  static String getBugReportUrl() => bugReportUrl;
  static String getMailToForFeedback() => mailToForFeedback;
  static String getSourceCodeUrl() => sourceCodeUrl;
  static String getAppName() => appName;
  static String getAppSlogan() => appSlogan;
  static String getUndecryptedLoginButtonText() => undecryptedLoginButtonText;
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
