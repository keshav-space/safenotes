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
import 'package:easy_localization/easy_localization.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/backup_import.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/styles.dart';
import 'package:safenotes/utils/url_launcher.dart';
import 'package:safenotes/widgets/dark_mode.dart';
import 'package:safenotes/widgets/footer.dart';

class SettingsScreen extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  SettingsScreen({Key? key, required this.sessionStateStream})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings'.tr(),
          style: appBarTitle,
        ),
      ),
      body: _settings(),
    );
  }

  Widget _settings() {
    return SettingsList(
      platform: DevicePlatform.iOS,
      lightTheme: SettingsThemeData(),
      darkTheme: SettingsThemeData(
        settingsListBackground: AppThemes.darkSettingsScaffold,
        settingsSectionBackground: AppThemes.darkSettingsCanvas,
      ),
      sections: [
        SettingsSection(
          title: Text('General'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.backup_outlined),
              title: Text('Backup'.tr()),
              value: PreferencesStorage.isBackupOn
                  ? Text('On'.tr())
                  : Text('Off'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/backup');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.fileDownloadOutline),
              title: Text('Import Backup'.tr()),
              onPressed: (context) async {
                await showImportDialog(context);
              },
            ),
            SettingsTile.switchTile(
              leading: Icon(MdiIcons.arrowCollapseVertical),
              title: Text('Compact Notes'.tr()),
              initialValue: PreferencesStorage.isCompactPreview,
              onToggle: (bool value) {
                PreferencesStorage.setIsCompactPreview(value);
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('Dark Mode'.tr()),
              value: !PreferencesStorage.isAutoRotate
                  ? Text('Off'.tr())
                  : Text('On'.tr()),
              onPressed: (context) {
                darkModalBottomSheet(context);
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.screen_rotation_outlined),
              title: Text('Auto Rotate'.tr()),
              value: !PreferencesStorage.isAutoRotate
                  ? Text('Off'.tr())
                  : Text('On'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/autoRotateSettings');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint_outlined),
              // leading: Icon(Icons.format_paint),
              title: Text('Notes Color'.tr()),
              value: !PreferencesStorage.isColorful
                  ? Text('Off'.tr())
                  : Text('On'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/chooseColorSettings');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.language_outlined),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Language'.tr()),
                  if (context.locale.toString() != 'en_US')
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Language',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              value: Text(
                  SafeNotesConfig.mapLocaleName[context.locale.toString()]!),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/chooseLanguageSettings');
                setState(() {});
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Security'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(MdiIcons.fingerprint),
              title: Text('Biometric'.tr()),
              value: PreferencesStorage.isBiometricAuthEnabled
                  ? Text('On'.tr())
                  : Text('Off'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/biometricSetting');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.cellphoneKey),
              title: Text('Logout on Inactivity'.tr()),
              value: Text(inactivityTimeoutValue()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/inactivityTimerSettings');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.phonelink_lock),
              title: Text('Secure Display'.tr()),
              value: PreferencesStorage.isFlagSecure
                  ? Text('On'.tr())
                  : Text('Off'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/secureDisplaySetting');
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              leading: Icon(MdiIcons.incognito),
              title: Text('Incognito Keyboard'.tr()),
              initialValue: PreferencesStorage.keyboardIncognito,
              onToggle: (bool value) {
                PreferencesStorage.setKeyboardIncognito(
                    !PreferencesStorage.keyboardIncognito);
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              title: Text('Change Passphrase'.tr()),
              leading: Icon(Icons.lock_outline),
              // leading: Icon(Icons.lock),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/changepassphrase');
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.logout),
              title: Text('Logout'.tr()),
              onPressed: (context) async {
                Session.logout();
                widget.sessionStateStream.add(SessionState.stopListening);
                await Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                  arguments: SessionArguments(
                    sessionStream: widget.sessionStateStream,
                    isKeyboardFocused: false,
                  ),
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Miscellaneous'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.rate_review_outlined),
              title: Text('Rate Us'.tr()),
              onPressed: (_) async {
                String playstoreUrl = SafeNotesConfig.playStoreUrl;
                try {
                  await launchUrlExternal(Uri.parse(playstoreUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.frequentlyAskedQuestions),
              title: Text('FAQs'.tr()),
              onPressed: (_) async {
                String faqsUrl = SafeNotesConfig.FAQsUrl;
                try {
                  await launchUrlExternal(Uri.parse(faqsUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.github),
              title: Text('Source Code'.tr()),
              onPressed: (_) async {
                String sourceCodeUrl = SafeNotesConfig.githubUrl;
                try {
                  await launchUrlExternal(Uri.parse(sourceCodeUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.mail_outline),
              title: Text('Email'.tr()),
              onPressed: (_) async {
                String email = SafeNotesConfig.mailToForFeedback;
                try {
                  await launchUrlExternal(Uri.parse(email));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.collections_bookmark_outlined),
              title: Text('Open Source license'.tr()),
              onPressed: (_) async {
                String license = SafeNotesConfig.openSourceLicense;
                try {
                  await launchUrlExternal(Uri.parse(license));
                } catch (e) {}
              },
              description:
                  Padding(padding: EdgeInsets.only(top: 20), child: footer()),
            ),
          ],
        ),
      ],
    );
  }

  String inactivityTimeoutValue() {
    var index = PreferencesStorage.inactivityTimeoutIndex;
    List<int> values = [30, 1, 2, 3, 5, 10, 15];
    if (index < 1) return '${values[index]} sec';
    return '${values[index]} min';
  }
}
