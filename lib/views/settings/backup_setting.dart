// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:workmanager/workmanager.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/utils/sheduled_task.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/utils/style.dart';

class BackupSetting extends StatefulWidget {
  BackupSetting({Key? key}) : super(key: key);

  @override
  State<BackupSetting> createState() => _BackupSettingState();
}

class _BackupSettingState extends State<BackupSetting> {
  String validChoosenDirectory = '';
  String lastUpdateTime = '';
  bool isBackupOn = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    // get valid path else empty string
    String path = await PreferencesStorage.getBackupDestination();

    setState(() {
      this.validChoosenDirectory = path;
    });

    String lastBackupTime = PreferencesStorage.getLastBackupTime();
    if (validChoosenDirectory.isNotEmpty) {
      var date = await File(
              '${validChoosenDirectory}/${SafeNotesConfig.getBackupFileName()}')
          .lastModified();
      lastBackupTime = date.toIso8601String();
    }

    setState(() {
      this.lastUpdateTime = lastBackupTime;
      this.isBackupOn = PreferencesStorage.getIsBackupOn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auto Backup')),
      body: _bodyBackup(context),
    );
  }

  Widget _bodyBackup(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.iOS,
      //lightTheme: SettingsThemeData(),
      darkTheme: SettingsThemeData(
        settingsListBackground: NordColors.polarNight.darkest,
        settingsSectionBackground: NordColors.polarNight.darker,
      ),
      sections: [
        SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: PreferencesStorage.getIsBackupOn(),
              title: Text('Auto Backup'),
              onToggle: (value) async {
                if (value == true) {
                  if (validChoosenDirectory.isNotEmpty) backupRegister();
                } else
                  Workmanager().cancelAll();
                await PreferencesStorage.setIsBackupOn(value);
                setState(() => isBackupOn = value);
              },
              description: Text(
                  'Turn on the auto backup and Choose backup folder from below.'),
            ),
          ],
        ),
        CustomSettingsSection(
          child: CupertinoPageScaffold(
            child: Column(
              children: [
                iosStylePaddedCard(
                  children: <Widget>[
                    _buildUpperBackupView(),
                    SizedBox(height: 10),
                    Text(SafeNotesConfig.getBackupDetail()),
                    _buildButtons(context),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget iosStylePaddedCard({required List<Widget> children}) {
    final double widthRatio = MediaQuery.of(context).size.width / 100;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthRatio * 5),
      child: Container(
        decoration: PreferencesStorage.getIsThemeDark()
            ? BoxDecoration(
                color: NordColors.polarNight.darker,
                borderRadius: BorderRadius.circular(15),
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpperBackupView() {
    var location = this.validChoosenDirectory.isEmpty
        ? 'Backup folder not choosen'
        : '${this.validChoosenDirectory}/${SafeNotesConfig.getBackupFileName()}';
    var lastBackup = this.lastUpdateTime.isEmpty
        ? 'Never'
        : timeago.format(DateTime.parse(this.lastUpdateTime));
    var widthRatio = MediaQuery.of(context).size.width / 100;

    return Row(
      children: [
        Icon(
          Icons.backup,
          color: !PreferencesStorage.getIsThemeDark()
              ? NordColors.polarNight.lighter
              : null,
          size: (widthRatio * 15),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Backup: ${lastBackup}',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'Location: ${location}',
                style: TextStyle(fontSize: 10),
              ),
              if (this.validChoosenDirectory.isNotEmpty &&
                  this.lastUpdateTime.isNotEmpty)
                _encrypted(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _encrypted() {
    return Row(
      children: [
        Icon(
          Icons.lock,
          size: 15,
          color: Colors.green,
        ),
        Text(
          ' Backup encrypted',
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundLR = 10.0;
    final double paddingAroundB = 20.0;
    final double buttonTextFontSize = 16.0;
    final String nowButtonText = 'Backup Now';
    String chooseButtonText =
        validChoosenDirectory.isEmpty ? 'Choose Folder' : 'Change Folder';

    return Container(
      padding: EdgeInsets.fromLTRB(
          paddingAroundLR, paddingAroundB, paddingAroundLR, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 5.0,
            ),
            child: _buttonText(chooseButtonText, buttonTextFontSize),
            onPressed: this.isBackupOn ? onChooseOrChange : null,
          ),
          ElevatedButton(
            child: _buttonText(nowButtonText, buttonTextFontSize),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 5.0,
              backgroundColor: validChoosenDirectory.isNotEmpty
                  ? NordColors.aurora.green
                  : Colors.grey.shade600,
            ),
            onPressed: validChoosenDirectory.isNotEmpty && isBackupOn
                ? onBackupNow
                : null,
          ),
        ],
      ),
    );
  }

  void onBackupNow() {
    if (validChoosenDirectory.isNotEmpty) {
      ScheduledTask.backup();
      _refresh();
      //setState(() => _refresh());
    }
  }

  void onChooseOrChange() async {
    var newPath = await FilePicker.platform.getDirectoryPath();

    if (newPath != null) {
      PreferencesStorage.setBackupDestination(newPath);

      backupRegister();
      _refresh();
      showSnackBarMessage(context, 'Backup destination set!');
    } else {
      showSnackBarMessage(context, 'Destination not choosen!');
    }
  }

  void backupRegister() {
    Workmanager().registerPeriodicTask(
      "safenotes-task",
      "dailyBackup",
      tag: 'com.trisven.safenotes.dailybackup',
      frequency: Duration(hours: 15),
      initialDelay: Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresCharging: false,
        requiresBatteryNotLow: false,
        //requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Style.buttonTextStyle().copyWith(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
