// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/url_launcher.dart';

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
      appBar: AppBar(
        title: Text('Settings'),
      ),
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
          title: Text('General'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.backup),
              title: Text('Auto Backup'),
              value:
                  PreferencesStorage.getIsBackupOn() ? Text('On') : Text('Off'),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/backup');
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Mode'),
              initialValue: PreferencesStorage.getIsThemeDark(),
              onToggle: (bool value) {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(!PreferencesStorage.getIsThemeDark());
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint),
              title: Text('Notes Color'),
              value: !PreferencesStorage.getIsColorful()
                  ? Text('Off')
                  : Text('On'),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/chooseColorSettings');
                setState(() {});
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Security'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(MdiIcons.cellphoneKey),
              title: Text('LogOut on Inactivity'),
              value: Text(
                  '${(PreferencesStorage.getInactivityTimeout() / 60).round()} min'),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/inactivityTimerSettings');
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.phonelink_lock),
              title: Text('Secure Display'),
              value: PreferencesStorage.getIsFlagSecure()
                  ? Text('On')
                  : Text('Off'),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/secureDisplaySetting');
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              leading: Icon(MdiIcons.incognito),
              title: Text('Incognito Keyboard'),
              initialValue: PreferencesStorage.getKeyboardIncognito(),
              onToggle: (bool value) {
                PreferencesStorage.setKeyboardIncognito(
                    !PreferencesStorage.getKeyboardIncognito());
                setState(() {});
              },
              //value: Text('On'),
            ),
            SettingsTile.navigation(
              title: Text('Change Passphrase'),
              leading: Icon(Icons.lock),
              onPressed: (context) async {
                await Navigator.pushNamed(context, '/changepassphrase');
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
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
          title: Text('Misc'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.rate_review),
              title: Text('Rate Us'),
              onPressed: (_) async {
                String playstoreUrl = SafeNotesConfig.getPlayStoreUrl();
                try {
                  await launchUrlExternal(Uri.parse(playstoreUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(MdiIcons.github),
              title: Text('Source Code'),
              onPressed: (_) async {
                String sourceCodeUrl = SafeNotesConfig.getGithubUrl();
                try {
                  await launchUrlExternal(Uri.parse(sourceCodeUrl));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.mail),
              title: Text('Email'),
              onPressed: (_) async {
                String email = SafeNotesConfig.getMailToForFeedback();
                try {
                  await launchUrlExternal(Uri.parse(email));
                } catch (e) {}
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.collections_bookmark),
              title: Text('Open Source license'),
              onPressed: (_) async {
                String licence = SafeNotesConfig.getOpenSourceLicence();
                try {
                  await launchUrlExternal(Uri.parse(licence));
                } catch (e) {}
              },
              description: _footer(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text("Safe Notes v2.0"),
          Text("Made with ♥ on Earth"),
        ],
      ),
    );
  }
}
