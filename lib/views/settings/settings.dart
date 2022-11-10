// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/select_export_folder.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/models/file_handler.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/utils/url_launcher.dart';
import 'package:safenotes/widgets/footer.dart';

class SettingsScreen extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  SettingsScreen({
    Key? key,
    required this.sessionStateStream,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'.tr())),
      body: _settings(),
    );
  }

  Widget _settings() {
    return SettingsList(
      platform: DevicePlatform.iOS,
      lightTheme: SettingsThemeData(),
      darkTheme: SettingsThemeData(
        settingsListBackground: NordColors.polarNight.darkest,
        settingsSectionBackground: NordColors.polarNight.darker,
      ),
      sections: [
        SettingsSection(
          title: Text('General'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.backup_outlined),
              title: Text('Auto Backup'),
              value: PreferencesStorage.getIsBackupOn()
                  ? Text('On'.tr())
                  : Text('Off'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/backup');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.file_upload_outlined),
              title: Text('Manual Export'.tr()),
              onPressed: (context) async {
                final String snackMsgFileNotSaved = 'File not saved!'.tr();
                bool wasExportMethordChoosen = false;
                try {
                  wasExportMethordChoosen = await showExportDialog(context);
                } catch (e) {
                  showSnackBarMessage(context, snackMsgFileNotSaved);
                  return;
                }
                if (!wasExportMethordChoosen) return;

                String? snackMsg = await FileHandler().fileSave();
                showSnackBarMessage(context, snackMsg);
              },
            ),
            SettingsTile.switchTile(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('Dark Mode'.tr()),
              initialValue: PreferencesStorage.getIsThemeDark(),
              onToggle: (bool value) {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(!PreferencesStorage.getIsThemeDark());
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint_outlined),
              // leading: Icon(Icons.format_paint),
              title: Text('Notes Color'.tr()),
              value: !PreferencesStorage.getIsColorful()
                  ? Text('Off'.tr())
                  : Text('On'.tr()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/chooseColorSettings');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.language_outlined),
              title: Text('Language'.tr()),
              value: Text(context.locale.toString()),
              onPressed: (context) async {
                // await Navigator.pushNamed(context, '/chooseLanguageSettings');
                // setState(() {});
              },
            )
          ],
        ),
        SettingsSection(
          title: Text('Security'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(MdiIcons.cellphoneKey),
              title: Text('LogOut on Inactivity'.tr()),
              value: Text(inactivityTimeoutValue()),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/inactivityTimerSettings');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.phonelink_lock),
              title: Text('Secure Display'.tr()),
              value: PreferencesStorage.getIsFlagSecure()
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
              initialValue: PreferencesStorage.getKeyboardIncognito(),
              onToggle: (bool value) {
                PreferencesStorage.setKeyboardIncognito(
                    !PreferencesStorage.getKeyboardIncognito());
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
              title: Text('LogOut'.tr()),
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
                String playstoreUrl = SafeNotesConfig.getPlayStoreUrl();
                try {
                  await launchUrlExternal(Uri.parse(playstoreUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.frequentlyAskedQuestions),
              title: Text('FAQs'.tr()),
              onPressed: (_) async {
                String faqsUrl = SafeNotesConfig.getFAQsUrl();
                try {
                  await launchUrlExternal(Uri.parse(faqsUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.github),
              title: Text('Source Code'.tr()),
              onPressed: (_) async {
                String sourceCodeUrl = SafeNotesConfig.getGithubUrl();
                try {
                  await launchUrlExternal(Uri.parse(sourceCodeUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.mail_outline),
              title: Text('Email'.tr()),
              onPressed: (_) async {
                String email = SafeNotesConfig.getMailToForFeedback();
                try {
                  await launchUrlExternal(Uri.parse(email));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.collections_bookmark_outlined),
              title: Text('Open Source license'.tr()),
              onPressed: (_) async {
                String licence = SafeNotesConfig.getOpenSourceLicence();
                try {
                  await launchUrlExternal(Uri.parse(licence));
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
    var index = PreferencesStorage.getInactivityTimeoutIndex();
    List<int> values = [30, 1, 2, 3, 5, 10, 15];
    if (index < 1) return '${values[index]} sec';
    return '${values[index]} min';
  }
}
