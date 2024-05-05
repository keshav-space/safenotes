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

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safenotes_nord_theme/safenotes_nord_theme.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/utils/scheduled_task.dart';
import 'package:safenotes/utils/storage_permission.dart';
import 'package:safenotes/utils/styles.dart';
import 'package:safenotes/utils/time_utils.dart';
import 'package:safenotes/widgets/login_button.dart';

class BackupSetting extends StatefulWidget {
  const BackupSetting({Key? key}) : super(key: key);

  @override
  State<BackupSetting> createState() => BackupSettingState();
}

class BackupSettingState extends State<BackupSetting> {
  String validWorkingBackupFullyQualifiedPath = '';
  String lastUpdateTime = '';
  bool isBackupOn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  Future<void> _refresh() async {
    PreferencesStorage.reload();

    String path = await getBackupIndicativePath();

    setState(() {
      validWorkingBackupFullyQualifiedPath = path;
      isBackupOn = PreferencesStorage.isBackupOn;
      refreshUpdateTime();
    });
  }

  Future<String> getBackupIndicativePath() async {
    String path = '';
    String lastBackupTime = PreferencesStorage.lastBackupTime;
    if (lastBackupTime.isEmpty) return path;

    if (Platform.isAndroid &&
        await Directory(SafeNotesConfig.androidBackupDirectory).exists()) {
      path = SafeNotesConfig.androidBackupDirectory +
          SafeNotesConfig.backupFileName;
    } else if (Platform.isIOS) {
      path = SafeNotesConfig.iosBackupDirectoryIndicativePath +
          SafeNotesConfig.backupFileName;
    }

    return path;
  }

  void refreshUpdateTime() {
    Locale currentLocale = Localizations.localeOf(context);
    String lastBackupTime = PreferencesStorage.lastBackupTime;

    lastBackupTime = lastBackupTime.isEmpty
        ? 'Never'.tr()
        : humanTime(
            time: DateTime.parse(lastBackupTime),
            localeString: currentLocale.toString(),
          );

    lastUpdateTime = lastBackupTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Backup'.tr(),
          style: appBarTitle,
        ),
      ),
      body: _bodyBackup(context),
    );
  }

  Widget _bodyBackup(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.iOS,
      darkTheme: SettingsThemeData(
        settingsListBackground: AppThemes.darkSettingsScaffold,
        settingsSectionBackground: AppThemes.darkSettingsCanvas,
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
                  await onBackupNow();
                }
                setState(() => isBackupOn = value);
              },
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
                    const SizedBox(height: 10),
                    Text(
                        "This will create an encrypted local backup, which gets automatically updated every day. Moreover, the backup is designed such that it can be used in tandem with other open-source tools like SyncThing to keep the multiple redundant backups across different devices on the local network.\nTo switch to a new device, you would simply need to copy this backup file to the new device and import that in your new Safe Notes app.\nFor more, see FAQ."
                            .tr()),
                    const SizedBox(height: 10),
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
                color: AppThemes.darkSettingsCanvas,
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
              ? AppThemes.darkSettingsCanvas
              : null,
          size: (widthRatio * 15),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Backup: {lastBackupTime}'
                    .tr(namedArgs: {'lastBackupTime': lastUpdateTime}),
                style: const TextStyle(fontSize: 10),
              ),
              _showLocationPath(context),
              if (validWorkingBackupFullyQualifiedPath.isNotEmpty &&
                  lastUpdateTime.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: _encrypted(),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _showLocationPath(context) {
    if (Platform.isIOS) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Location: {locationPath}'.tr(
                namedArgs: {
                  'locationPath': validWorkingBackupFullyQualifiedPath
                },
              ),
              style: TextStyle(
                color: NordColors.frost.darker,
                fontSize: 10,
              ),
              recognizer: TapGestureRecognizer()..onTap = onShowIosBackupDir,
            ),
            const WidgetSpan(
              child: SizedBox(width: 1),
            ),
            WidgetSpan(
              child: Icon(
                Icons.open_in_new,
                color: NordColors.frost.darker,
                size: 12,
              ),
            ),
          ],
        ),
      );
    }

    /*
    TODO: Support opening backup folder on Android native file manager
    As of now, there is no reliable way to open a particular folder in
    the file manager using the ACTION_VIEW intent.
    See: ghttps://github.com/keshav-space/safenotes/issues/193
    */
    return Text(
      'Location: {locationPath}'.tr(
        namedArgs: {'locationPath': validWorkingBackupFullyQualifiedPath},
      ),
      style: const TextStyle(fontSize: 10),
    );
  }

  Widget _encrypted() {
    return Row(
      children: [
        const Icon(
          Icons.lock,
          size: 15,
          color: Colors.green,
        ),
        const SizedBox(width: 1),
        Text(
          'Backup encrypted'.tr(),
          style: const TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget _buildBackupNowButton() {
    final String loginText = 'Backup Now'.tr();

    return ButtonWidget(
      text: loginText,
      onClicked: validWorkingBackupFullyQualifiedPath.isNotEmpty && isBackupOn
          ? onBackupNow
          : null,
    );
  }

  Future<void> onBackupNow() async {
    if (Platform.isAndroid) {
      await handleBackupPermissionAndLocation();
    }
    await ScheduledTask.backup();
    await _refresh();
  }
}

Future<void> onShowIosBackupDir() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String documentsPath = documentsDirectory.path;
  Uri uri = Uri.parse('shareddocuments://$documentsPath');

  await launchUrl(uri);
}

Future<bool> handleBackupPermissionAndLocation() async {
  if (!await handleStoragePermission()) return false;

  // If the download directory doesn't exists return false
  if (!await Directory(SafeNotesConfig.androidDownloadDirectory).exists()) {
    return false;
  }
  await Directory(SafeNotesConfig.androidBackupDirectory)
      .create(recursive: false);

  return true;
}
