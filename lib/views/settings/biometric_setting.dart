// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
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
        settingsListBackground: NordColors.polarNight.darkest,
        settingsSectionBackground: NordColors.polarNight.darker,
      ),
      sections: [
        SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.isBiometricAuthEnabled,
              title: Text('Enable biometric'.tr()),
              onToggle: (value) {
                if (value)
                  BiometricAuth.enable();
                else
                  BiometricAuth.disable();

                setState(() {});
              },
              description: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut aliquet purus leo, ut convallis libero pellentesque at. Morbi porta eget massa a condimentum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Aenean vehicula lacus bibendum, fringilla purus ut, cursus sem. In imperdiet risus lacus, ac lacinia quam cursus quis. Cras maximus urna tincidunt ipsum imperdiet, non varius urna tempus. Ut eros nunc, posuere in lobortis quis, lobortis eget nibh. Fusce non urna vel mi ultricies interdum at eu elit. Etiam eu consectetur ligula.'
                    .tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
