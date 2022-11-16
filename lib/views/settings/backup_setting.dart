// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:workmanager/workmanager.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/utils/sheduled_task.dart';
import 'package:safenotes/utils/storage_permission.dart';
import 'package:safenotes/widgets/login_button.dart';

class BackupSetting extends StatefulWidget {
  BackupSetting({Key? key}) : super(key: key);

  @override
  State<BackupSetting> createState() => _BackupSettingState();
}

class _BackupSettingState extends State<BackupSetting> {
  String validWorkingBackupFullyQualifiedPath = '';
  String lastUpdateTime = '';
  bool isBackupOn = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    PreferencesStorage.reload();
    // get valid path else empty string

    String lastBackupTime = PreferencesStorage.lastBackupTime;
    String path = '';
    if (lastBackupTime.isNotEmpty &&
        await Directory(SafeNotesConfig.backupDirectory).exists())
      path = SafeNotesConfig.backupDirectory + SafeNotesConfig.backupFileName;

    lastBackupTime = lastBackupTime.isEmpty
        ? 'Never'.tr()
        : timeago.format(DateTime.parse(lastBackupTime));

    setState(() {
      this.validWorkingBackupFullyQualifiedPath = path;
      this.lastUpdateTime = lastBackupTime;
      this.isBackupOn = PreferencesStorage.isBackupOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Backup'.tr())),
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
              initialValue: PreferencesStorage.isBackupOn,
              title: Text('Backup'.tr()),
              onToggle: (value) async {
                await PreferencesStorage.setIsBackupOn(value);
                if (value == true) {
                  if (await _handleBackupPermissionAndLocation() == true) {
                    backupRegister();
                    await onBackupNow();
                  }
                } else
                  Workmanager().cancelAll();
                setState(() => isBackupOn = value);
              },
              description: Text('autoBackupInstruction'.tr()),
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
                    Text('backupSummary'.tr()),
                    //_buildButtons(context),
                    SizedBox(height: 10),
                    _buildBackupNowButton()
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
        decoration: PreferencesStorage.isThemeDark
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
    var widthRatio = MediaQuery.of(context).size.width / 100;

    return Row(
      children: [
        Icon(
          Icons.backup,
          color: !PreferencesStorage.isThemeDark
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
                'lastBackupTime'
                    .tr(namedArgs: {'lastBackupTime': this.lastUpdateTime}),
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'backupLocationPath'.tr(namedArgs: {
                  'locationPath': this.validWorkingBackupFullyQualifiedPath
                }),
                style: TextStyle(fontSize: 10),
              ),
              if (this.validWorkingBackupFullyQualifiedPath.isNotEmpty &&
                  this.lastUpdateTime.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: _encrypted(),
                )
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
        SizedBox(width: 1),
        Text(
          'Backup encrypted'.tr(),
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget _buildBackupNowButton() {
    final String loginText = 'Backup Now'.tr();

    return ButtonWidget(
      text: loginText,
      onClicked:
          validWorkingBackupFullyQualifiedPath.isNotEmpty && this.isBackupOn
              ? onBackupNow
              : null,
    );
  }

  Future<void> onBackupNow() async {
    await ScheduledTask.backup();
    await _refresh();
  }

  Future<bool> _handleBackupPermissionAndLocation() async {
    if (!await handleStoragePermission()) return false;

    // create Safe Notes folder if doesn't exist
    if (this.validWorkingBackupFullyQualifiedPath.isEmpty) {
      // If the download directory doesn't exists return false
      if (!await Directory(SafeNotesConfig.downloadDirectory).exists())
        return false;
      await Directory(SafeNotesConfig.backupDirectory).create(recursive: false);
    }
    return true;
  }
}

void backupRegister() {
  Workmanager().cancelByTag('com.trisven.safenotes.dailybackup');

  Workmanager().registerPeriodicTask(
    "safenotes-task",
    "dailyBackup",
    existingWorkPolicy: ExistingWorkPolicy.replace,
    tag: 'com.trisven.safenotes.dailybackup',
    frequency: Duration(hours: 15),
    initialDelay: Duration(seconds: 1),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresCharging: false,
      requiresBatteryNotLow: false,
      //requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
}
