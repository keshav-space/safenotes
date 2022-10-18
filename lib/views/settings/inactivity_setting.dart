// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:settings_ui/settings_ui.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class InactivityTimerSetting extends StatefulWidget {
  InactivityTimerSetting({Key? key}) : super(key: key);

  @override
  State<InactivityTimerSetting> createState() => _InactivityTimerSettingState();
}

class _InactivityTimerSettingState extends State<InactivityTimerSetting> {
  var _selectedIndex = PreferencesStorage.getInactivityTimeoutIndex();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inactiviy Timeout')),
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
          title: Text('Always on'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.getIsColorful(),
              title: Text('Logout upon inactivity'),
              onToggle: (value) {},
              enabled: false,
              description: Text('Close and open app for change to take effect'),
            ),
          ],
        ),
        CustomSettingsSection(
          child: CustomSettingsTile(
            child: _buildTimeList(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeList(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: CupertinoFormSection.insetGrouped(
          backgroundColor: PreferencesStorage.getIsThemeDark()
              ? NordColors.polarNight.darkest
              : Color(0x00000000),
          decoration: PreferencesStorage.getIsThemeDark()
              ? BoxDecoration(
                  color: NordColors.polarNight.darker,
                  borderRadius: BorderRadius.circular(15),
                  //border: Border.all(color: Colors.blueAccent),
                )
              : null,
          children: [
            ...List.generate(
              items.length,
              (index) => GestureDetector(
                onTap: () => setState(() {
                  _selectedIndex = index;
                  PreferencesStorage.setInactivityTimeoutIndex(index: index);
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

class Item {
  final String prefix;
  final String? helper;
  const Item({required this.prefix, this.helper});
}

const items = [
  Item(prefix: '4 minutes', helper: null),
  Item(prefix: '6 minutes', helper: 'Default'),
  Item(prefix: '8 minutes', helper: null),
  Item(prefix: '10 minutes', helper: null),
];
