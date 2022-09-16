import 'package:shared_preferences/shared_preferences.dart';

class AppSecurePreferencesStorage {
  static SharedPreferences? _preferences;

  static const _keyPassPhraseHash = 'passphrasehash';
  static const _keyAllowUndecryptLoginFlag = 'undecryptLoginFlag';
  static const _keyIsThemeDark = 'isthemedark';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setPassPhraseHash(String passphrasehash) async =>
      await _preferences?.setString(_keyPassPhraseHash, passphrasehash);
  static String? getPassPhraseHash() => _preferences?.getString(_keyPassPhraseHash);

  static Future setAllowUndecryptLoginFlag(bool flag) async =>
      await _preferences?.setBool(_keyAllowUndecryptLoginFlag, flag);
  static bool getAllowUndecryptLoginFlag() {
    bool? localFlag = _preferences?.getBool(_keyAllowUndecryptLoginFlag);
    localFlag ??= true;
    return localFlag;
  }

  static Future setIsThemeDark(bool flag) async =>
      await _preferences?.setBool(_keyIsThemeDark, flag);

  static bool getIsThemeDark() {
    bool? localFlag = _preferences?.getBool(_keyIsThemeDark);
    localFlag ??= true;
    return localFlag;
  }
}

class PhraseHandler {
  static String passphrase = "";

  static initPass(String pass) => passphrase = pass;

  static String getPass() => passphrase;
}

class UnDecryptedLoginControl {
  static getAllowLogUnDecrypted() =>
      AppSecurePreferencesStorage.getAllowUndecryptLoginFlag();

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
  static getImportPassPhrase() => importPassPhrase;
  static setImportPassPhrase(String imPhrase) => importPassPhrase = imPhrase;
}

class AppInfo {
  static String appName = 'Safe Notes';
  static String appSlogan = 'Heaven for your data!';
  static String firstLoginPageName = 'Set Encryption Phrase';
  static String loginPageName = 'Vault Login';
  static String undecryptedLoginButtonText = 'Nah! Show Un-Decrypted';
  static String appLogoPath = 'assets/splash_500.png';
  static String appLogoAsProfilePath =
      'assets/splash.png'; //'assets/hexa_profile.png';
  static String exportFileNamePrefix = 'vault_export_';
  static String exportFileNameExtension = 'json';
  static String importDialogMsg =
      'If your import file is encrypted then you\'ll be prompted to enter the passphrase of the device that generated this export.';
  static String exportDialogMsg =
      'We recommend using the encrypted export method, this will encrypt your data using your current encryption passphrase. \nYou will be prompted to enter your passphrase while importing it.';
  static String mailToForFeedback =
      'mailto:safenotes@keshav.space?subject=Help and Feedback';
  static String sourceCodeUrl =
      'https://safenotes.keshav.space/sourcecode';
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
