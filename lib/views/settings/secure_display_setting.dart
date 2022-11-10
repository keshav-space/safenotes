// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
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
      appBar: AppBar(title: Text('Secure Display'.tr())),
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
          title: Text('Close and open app for change to take effect'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.getIsFlagSecure(),
              title: Text('Secure Display'.tr()),
              onToggle: (value) {
                PreferencesStorage.setIsFlagSecure(value);
                setState(() {});
              },
              description: Text('secureDisplaySummary'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}
