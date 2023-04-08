// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/utils/styles.dart';

class AutoRotationSetting extends StatefulWidget {
  AutoRotationSetting({Key? key}) : super(key: key);

  @override
  State<AutoRotationSetting> createState() => _AutoRotationSettingState();
}

class _AutoRotationSettingState extends State<AutoRotationSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Auto Rotate'.tr(),
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
          title: Text('Close and open app for change to take effect'.tr()),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.isAutoRotate,
              title: Text('Auto Rotate'.tr()),
              onToggle: (value) {
                PreferencesStorage.setIsAutoRotate(value);
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }
}
