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
import 'package:safenotes/utils/backup_shedule.dart';
import 'package:safenotes/utils/snack_message.dart';

class Backup extends StatefulWidget {
  Backup({Key? key}) : super(key: key);

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  late String validChoosenDirectory = '';
  late String lastUpdateTime = '';
  late bool isBackupOn = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    // get valid path else empty string
    validChoosenDirectory = await PreferencesStorage.getBackupDestination();
    lastUpdateTime = PreferencesStorage.getLastBackupTime();
    isBackupOn = PreferencesStorage.getIsBackupOn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Backup'),
      ),
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
                setState(() {
                  isBackupOn = value;
                });
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
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pharetra posuere sapien. Duis ornare ullamcorper feugiat. Pellentesque at risus at est fermentum suscipit. Vestibulum sit amet pharetra magna, quis tincidunt nunc. Morbi posuere elementum tincidunt. Nullam a efficitur metus. Donec consectetur ut turpis vitae ultrices. Vivamus semper vitae ex pulvinar facilisis. Pellentesque volutpat lobortis nunc vitae vehicula. ',
                      //style: Styles.productRowItemName,
                    ),
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
        : this.validChoosenDirectory;
    var lastBackup = this.lastUpdateTime.isEmpty
        ? 'Never'
        : timeago.format(DateTime.parse(this.lastUpdateTime));

    var widthRatio = MediaQuery.of(context).size.width / 100;

    return Row(
      children: [
        Icon(
          Icons.backup,
          color: !PreferencesStorage.getIsThemeDark()
              ? Colors.grey.shade600
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundLR = 10.0;
    final double paddingAroundB = 20.0;
    final double buttonTextFontSize = 16.0;
    final String nowButtonText = 'Backup Now';
    String chooseButtonText =
        validChoosenDirectory.isEmpty ? 'Choose folder' : 'Change folder';

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
      setState(() {
        _refresh();
      });
    }
  }

  void onChooseOrChange() async {
    var newPath = await FilePicker.platform.getDirectoryPath();
    if (newPath != null) {
      PreferencesStorage.setBackupDestination(newPath);
      //ScheduledTask.backup();
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
      frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 10),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
