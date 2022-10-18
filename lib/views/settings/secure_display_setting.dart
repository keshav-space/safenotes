// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class SecureDisplaySetting extends StatefulWidget {
  SecureDisplaySetting({Key? key}) : super(key: key);

  @override
  State<SecureDisplaySetting> createState() => _SecureDisplaySettingState();
}

class _SecureDisplaySettingState extends State<SecureDisplaySetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secure Display')),
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
          title: Text('Close and open app for change to take effect'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.getIsFlagSecure(),
              title: Text('Secure Display'),
              onToggle: (value) {
                PreferencesStorage.setIsFlagSecure(value);
                setState(() {});
              },
              description: Text(
                  'When turned on, the content on the screen is treated as secure, blocking background snapshots and preventing it from appearing in screenshots or from being viewed on non-secure displays.'),
            ),
          ],
        ),
      ],
    );
  }
}
