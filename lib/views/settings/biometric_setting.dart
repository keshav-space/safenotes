// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/models/biometric_auth.dart';

class BiometricSetting extends StatefulWidget {
  BiometricSetting({Key? key}) : super(key: key);

  @override
  State<BiometricSetting> createState() => _BiometricSettingState();
}

class _BiometricSettingState extends State<BiometricSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Biometric'.tr())),
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
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.isBiometricAuthEnabled,
              title: Text('Enable biometric authentication'.tr()),
              onToggle: (value) {
                if (value)
                  BiometricAuth.enable();
                else
                  BiometricAuth.disable();

                setState(() {});
              },
              description: Text(
                "Users are advised to assess their threat perception before enabling biometric authentication. Don't enable this if you're storing state secrets! Visit FAQs for more information."
                    .tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
