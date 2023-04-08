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

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/utils/styles.dart';

class SecureDisplaySetting extends StatefulWidget {
  SecureDisplaySetting({Key? key}) : super(key: key);

  @override
  State<SecureDisplaySetting> createState() => _SecureDisplaySettingState();
}

class _SecureDisplaySettingState extends State<SecureDisplaySetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Secure Display'.tr(),
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
              initialValue: PreferencesStorage.isFlagSecure,
              title: Text('Secure Display'.tr()),
              onToggle: (value) {
                PreferencesStorage.setIsFlagSecure(value);
                setState(() {});
              },
              description: Text(
                  'When turned on, the content on the screen is treated as secure, blocking background snapshots and preventing it from appearing in screenshots or from being viewed on non-secure displays.'
                      .tr()),
            ),
          ],
        ),
      ],
    );
  }
}
