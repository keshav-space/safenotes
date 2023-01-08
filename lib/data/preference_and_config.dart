// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class PreferencesStorage {
  static SharedPreferences? _preferences;

  static const _keyPassPhraseHash = 'passphrasehash';
  static const _keyIsThemeDark = 'isthemedark';
  static const _keyKeyboardIncognito = 'keyboardIcognito';
  static const _keyIsInactivityTimeoutOn = 'isInactivityTimeoutOn';
  static const _keyInactivityTimeout = 'inactivityTimeout';
  //static const _keyFocusTimeout = 'focusTimeout';
  static const _keyPreInactivityLogoutCounter = 'preInactivityLogoutCounter';
  static const _keyNoOfLogginAttemptAllowed = 'noOfLogginAttemptAllowed';
  static const _keyBruteforceLockOutTime = 'bruteforceLockOutTime';
  static const _keyIsColorful = 'isColorful';
  static const _keyLastBackupTime = 'lastBackupTime';
  static const _keyIsBackupOn = 'isBackupOn';
  static const _keyColorfulNotesColorIndex = 'colorfulNotesColorIndex';
  static const _keyIsGridView = 'isGridView';
  static const _keyIsNewFirst = 'isNewFirst';
  static const _keyIsFlagSecure = 'isFlagSecure';
  static const _keyBackupRedundancyCounter = 'backupRedundancyCounter';
  static const _keyMaxBackupRetryAttempts = 'maxBackupRetryAttempts';
  static const _keyAppVersionCode = 'appVersionCode';
  static const _keyIsBiometricAuthEnabled = 'isBiometricAuthEnabled';
  static const _keyBiometricAttemptAllTimeCount =
      'biometricAttemptAllTimeCount';
  static const _keyIsCompactPreview = 'isCompactPreview';
  static const _keyIsDimTheme = 'isDimTheme';
  static const _keyDarkModeEnum = 'isDarkModeEnum';
  static const _keyDarkThemeEnum = 'isDarkThemeEnum';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static reload() => _preferences?.reload();

  static Future<void> setPassPhraseHash(String passphrasehash) async =>
      await _preferences?.setString(_keyPassPhraseHash, passphrasehash);

  static String get passPhraseHash =>
      _preferences?.getString(_keyPassPhraseHash) ?? '';

// appVersionCode controls the one time code excution on version change
  static int get appVersionCode =>
      _preferences?.getInt(_keyAppVersionCode) ?? 1;

  static Future<void> setAppVersionCodeToCurrent() async => await _preferences
      ?.setInt(_keyAppVersionCode, SafeNotesConfig.appVersionCode);

  static int get colorfulNotesColorIndex =>
      _preferences?.getInt(_keyColorfulNotesColorIndex) ?? 0;

  static Future<void> setColorfulNotesColorIndex(int index) async =>
      await _preferences?.setInt(_keyColorfulNotesColorIndex, index);

  static bool get isThemeDark {
    bool? isDark = _preferences?.getBool(_keyIsThemeDark);
    if (isDark != null) return isDark;
    return WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  static Future<void> setIsThemeDark(bool flag) async =>
      await _preferences?.setBool(_keyIsThemeDark, flag);

  static int get backupRedundancyCounter =>
      _preferences?.getInt(_keyBackupRedundancyCounter) ?? 0;

  static Future<void> incrementBackupRedundancyCounter() async =>
      await _preferences?.setInt(_keyBackupRedundancyCounter,
          PreferencesStorage.backupRedundancyCounter + 1);

  static bool get isFlagSecure =>
      _preferences?.getBool(_keyIsFlagSecure) ?? true;

  static Future<void> setIsFlagSecure(bool flag) async =>
      await _preferences?.setBool(_keyIsFlagSecure, flag);

  static bool get isGridView => _preferences?.getBool(_keyIsGridView) ?? true;

  static Future<void> setIsGridView(bool flag) async =>
      await _preferences?.setBool(_keyIsGridView, flag);

  static bool get isNewFirst => _preferences?.getBool(_keyIsNewFirst) ?? true;

  static Future<void> setIsNewFirst(bool flag) async =>
      await _preferences?.setBool(_keyIsNewFirst, flag);

  static String get lastBackupTime =>
      _preferences?.getString(_keyLastBackupTime) ?? '';

  static Future<void> setLastBackupTime() async => await _preferences
      ?.setString(_keyLastBackupTime, DateTime.now().toIso8601String());

  static bool get isBackupOn =>
      _preferences?.getBool(_keyIsBackupOn) ?? false; //true;

  static Future<void> setIsBackupOn(bool flag) async =>
      await _preferences?.setBool(_keyIsBackupOn, flag);

  static bool get isColorful => _preferences?.getBool(_keyIsColorful) ?? true;

  static Future<void> setIsColorful(bool flag) async =>
      await _preferences?.setBool(_keyIsColorful, flag);

  static Future<void> setKeyboardIncognito(bool flag) async =>
      await _preferences?.setBool(_keyKeyboardIncognito, flag);

  static bool get keyboardIncognito =>
      _preferences?.getBool(_keyKeyboardIncognito) ?? true;

  static int get noOfLogginAttemptAllowed {
    //default: 3 unsucessful
    return _preferences?.getInt(_keyNoOfLogginAttemptAllowed) ?? 4;
  }

  static int get bruteforceLockOutTime {
    //default: 30 seconds
    return _preferences?.getInt(_keyBruteforceLockOutTime) ?? 30;
  }

  static bool get isInactivityTimeoutOn =>
      _preferences?.getBool(_keyIsInactivityTimeoutOn) ?? true;

  static Future<void> setIsInactivityTimeoutOn(bool flag) async =>
      await _preferences?.setBool(_keyIsInactivityTimeoutOn, flag);

  static int get inactivityTimeout {
    //default: 4 minutes

    List<int> choices = [30, 60, 120, 180, 300, 600, 900];
    var index = _preferences?.getInt(_keyInactivityTimeout);
    if (!(index != null && index >= 0 && index < choices.length))
      index = 4; // default

    return choices[index];
  }

  static int get inactivityTimeoutIndex =>
      _preferences?.getInt(_keyInactivityTimeout) ?? 3;

  static Future<void> setInactivityTimeoutIndex({required int index}) async =>
      await _preferences?.setInt(_keyInactivityTimeout, index);

//default: Same as inactivityTimeout
  static int get focusTimeout => PreferencesStorage.inactivityTimeout;
  // static int get focusTimeout => _preferences?.getInt(_keyFocusTimeout) ?? 60;

  //default: 50
  static int get maxBackupRetryAttempts =>
      _preferences?.getInt(_keyMaxBackupRetryAttempts) ?? 50;

  //for logout popup alert. default: 15 seconds
  static int get preInactivityLogoutCounter =>
      _preferences?.getInt(_keyPreInactivityLogoutCounter) ?? 15;

  // static Future<void> setFocusTimeout({required int minutes}) async {
  //   await _preferences?.setInt(_keyFocusTimeout, minutes * 60);
  // }

  // static Future<void> setPreInactivityLogoutCounter(
  //     {required int seconds}) async {
  //   await _preferences?.setInt(_keyPreInactivityLogoutCounter, seconds);
  // }
  static bool get isBiometricAuthEnabled =>
      _preferences?.getBool(_keyIsBiometricAuthEnabled) ?? false;
  static Future<void> setIsBiometricAuthEnabled(bool flag) async =>
      await _preferences?.setBool(_keyIsBiometricAuthEnabled, flag);

  static int get biometricAttemptAllTimeCount =>
      _preferences?.getInt(_keyBiometricAttemptAllTimeCount) ?? 0;

  static Future<void> incrementBiometricAttemptAllTimeCount() async =>
      await _preferences?.setInt(_keyBiometricAttemptAllTimeCount,
          PreferencesStorage.biometricAttemptAllTimeCount + 1);

  static bool get isCompactPreview =>
      _preferences?.getBool(_keyIsCompactPreview) ?? false;
  static Future<void> setIsCompactPreview(bool flag) async =>
      await _preferences?.setBool(_keyIsCompactPreview, flag);

  static bool get isDimTheme => _preferences?.getBool(_keyIsDimTheme) ?? true;
  static Future<void> setIsDimTheme(bool flag) async =>
      await _preferences?.setBool(_keyIsDimTheme, flag);

  //Default is the device settings. i.e enumIndex = 2
  static int get darkModeEnum => _preferences?.getInt(_keyDarkModeEnum) ?? 2;
  static Future<void> setDarkModeEnum({required int index}) async =>
      await _preferences?.setInt(_keyDarkModeEnum, index);

  //Default is Dim. i.e enumIndex = 0
  static int get darkThemeEnum => _preferences?.getInt(_keyDarkThemeEnum) ?? 0;
  static Future<void> setDarkThemeEnum({required int index}) async =>
      await _preferences?.setInt(_keyDarkThemeEnum, index);
}

class PhraseHandler {
  static String _passphrase = '';

  static initPass(String pass) => _passphrase = pass;
  static destroy() => _passphrase = '';

  static String get getPass => _passphrase;
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
  static String _appVersion = '2.2.0';
  static int _appVersionCode = 9;
  static String _appName = 'Safe Notes';
  static String _appSlogan = 'Encrypted note manager!';
  static String _appLogoPath = 'assets/images/splash_500.png';
  static String _appLogoAsProfilePath = 'assets/images/splash.png';
  static String _exportFileNamePrefix = 'safenotes_';
  static String _allowedFileExtensionsForImport = 'json';
  static String _exportFileNameExtension = '.json';
  static String _backupExtension = '.json';
  static String _backupFileNamePrefix = 'safenotes_backup';
  static String _githubUrl = 'https://github.com/keshav-space/safenotes';
  static String _faqsUrl = 'https://safenotes.dev/faqs.html';
  static String _downloadDirectory = '/storage/emulated/0/Download/';
  static String _backupDirectory = '/storage/emulated/0/Download/Safe Notes/';
  static String _mailToForFeedback =
      'mailto:contact@safenotes.dev?subject=Help and Feedback';
  static String _sourceCodeUrl = 'https://github.com/keshav-space/safenotes';
  static String _bugReportUrl =
      'mailto:contact@safenotes.dev?subject=Bug Report';
  static String _openSourceLicence =
      'https://github.com/keshav-space/safenotes/blob/main/LICENSE';
  static String _playStorUrl =
      'https://play.google.com/store/apps/details?id=com.trisven.safenotes';

  static Map<String, Locale> _locales = {
    "English": Locale('en', 'US'),
    "简体中文": Locale('zh', 'CN'),
    "Français": Locale('fr'),
    "Português": Locale('pt'),
    "Português do Brasil": Locale('pt', 'BR'),
    "Русский": Locale('ru'),
    "Türk": Locale('tr'),
    "Deutsch": Locale('de'),
    "Polski": Locale('pl'),
  };

  // set timeago local for all supported language
  static void setTimeagoLocale() {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrMessages());
    timeago.setLocaleMessages('pt', timeago.PtBrMessages());
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    timeago.setLocaleMessages('ru', timeago.RuMessages());
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setLocaleMessages('de', timeago.DeMessages());
    timeago.setLocaleMessages('pr', timeago.PlMessages());
  }

  static String get appName => _appName;
  static String get appVersion => _appVersion;
  static int get appVersionCode => _appVersionCode;
  static String get logoAsProfile => _appLogoAsProfilePath;
  static String get bugReportUrl => _bugReportUrl;
  static String get mailToForFeedback => _mailToForFeedback;
  static String get sourceCodeUrl => _sourceCodeUrl;
  static String get openSourceLicence => _openSourceLicence;
  static String get playStoreUrl => _playStorUrl;
  static String get githubUrl => _githubUrl;
  static String get appSlogan => _appSlogan;
  static String get appLogoPath => _appLogoPath;
  static String get exportFileExtension => _exportFileNameExtension;
  static String get importFileExtension => _allowedFileExtensionsForImport;
  static String get FAQsUrl => _faqsUrl;
  static String get downloadDirectory => _downloadDirectory;
  static String get backupDirectory => _backupDirectory;
  static Map<String, Locale> get allLocale => _locales;
  static List<Locale> get localesValues => _locales.values.toList();
  static List<String> get localesKeys => _locales.keys.toList();
  static List<LanguageItem> get languageItems {
    List<LanguageItem> items = [];
    localesKeys.forEach((element) {
      items.add(LanguageItem(prefix: element, helper: null));
    });
    return items;
  }

  static Map<String, String> get mapLocaleName {
    //{'en_US':'English'}
    Map<String, String> _mapLocaleName = Map();
    _locales.forEach((key, value) {
      _mapLocaleName[value.toString()] = key;
    });
    return _mapLocaleName;
  }

  static String get backupFileName {
    String redundancyCounter =
        PreferencesStorage.backupRedundancyCounter.toString();
    if (redundancyCounter == '0')
      return '${_backupFileNamePrefix}${_backupExtension}';
    return '${_backupFileNamePrefix}${redundancyCounter}${_backupExtension}';
  }

  static String get exportFileName {
    var dateNow = DateTime.now()
        .toString()
        .replaceAll("-", "")
        .replaceAll(" ", "_")
        .replaceAll(":", "")
        .substring(0, 15);
    return (_exportFileNamePrefix + dateNow + _exportFileNameExtension);
  }
}

class LanguageItem {
  final String prefix;
  final String? helper;
  const LanguageItem({required this.prefix, this.helper});
}
