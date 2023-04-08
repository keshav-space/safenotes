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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/utils/styles.dart';

class LanguageSetting extends StatefulWidget {
  LanguageSetting({Key? key}) : super(key: key);

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language'.tr(),
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
        CustomSettingsSection(
          child: CustomSettingsTile(
            child: _buildLanguageList(context),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageList(BuildContext context) {
    var _selectedIndex = 0;
    if (SafeNotesConfig.mapLocaleName.containsKey(context.locale.toString()))
      _selectedIndex = indexofLanguage(
          SafeNotesConfig.mapLocaleName[context.locale.toString()]!);

    var items = SafeNotesConfig.languageItems;

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: CupertinoFormSection.insetGrouped(
          backgroundColor: PreferencesStorage.isThemeDark
              ? AppThemes.darkSettingsScaffold
              : Color(0x00000000),
          decoration: PreferencesStorage.isThemeDark
              ? BoxDecoration(
                  color: AppThemes.darkSettingsCanvas,
                  borderRadius: BorderRadius.circular(15),
                )
              : null,
          children: [
            ...List.generate(
              items.length,
              (index) => GestureDetector(
                onTap: () => setState(() {
                  _selectedIndex = index;
                  context.setLocale(
                      SafeNotesConfig.allLocale[items[index].prefix]!);
                  setState(() {});
                }),
                child: AbsorbPointer(
                  child: buildCupertinoFormRow(
                    items[index].prefix,
                    items[index].helper,
                    selected: _selectedIndex == index,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCupertinoFormRow(
    String prefix,
    String? helper, {
    bool selected = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: CupertinoFormRow(
        prefix: Text(prefix),
        helper: helper != null
            ? Text(
                helper,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        child: selected
            ? const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: Color.fromARGB(255, 45, 118, 234),
                  size: 20,
                ),
              )
            : Container(),
      ),
    );
  }
}

int indexofLanguage(String language) {
  for (var i = 0; i < SafeNotesConfig.languageItems.length; i++)
    if (SafeNotesConfig.languageItems[i].prefix == language) return i;
  return 0;
}
