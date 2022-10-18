// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/utils/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  final VoidCallback onImportCallback;
  final VoidCallback onExportCallback;
  final VoidCallback onChangePassCallback;
  final VoidCallback onLogoutCallback;
  final VoidCallback onSettingsCallback;

  HomeDrawer({
    Key? key,
    required this.onImportCallback,
    required this.onExportCallback,
    required this.onChangePassCallback,
    required this.onLogoutCallback,
    required this.onSettingsCallback,
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final drawerPaddingHorizontal = 15.0;
    final double itemSpacing = 0.0;
    final double dividerSpacing = 0.0;
    final double drawerRadius = 15.0;

    final String importDataText = 'Import Data';
    final String exportDataText = 'Export Data';
    final String changePassText = 'Change Passphrase';
    final String darkModeText = 'Dark Mode';
    final String lightModeText = 'Light Mode';
    final String helpText = 'Help and Feedback';
    final String sourceCodeText = 'Source Code';
    final String reportBugText = 'Report Bug';
    final String logoutText = 'LogOut';

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(drawerRadius),
        bottomRight: Radius.circular(drawerRadius),
      ),
      child: Drawer(
        child: Material(
          //color: Color.fromRGBO(0, 290, 55, 50),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: drawerPaddingHorizontal),
            children: <Widget>[
              _drawerHeader(topPadding: 70),
              _divide(topPadding: 15),
              _buildMenuItem(
                topPadding: 15,
                text: importDataText,
                icon: Icons.file_download_outlined,
                onClicked: widget.onImportCallback,
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: exportDataText,
                icon: Icons.file_upload_outlined,
                onClicked: widget.onExportCallback,
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: changePassText,
                icon: Icons.key,
                onClicked: widget.onChangePassCallback,
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: PreferencesStorage.getIsThemeDark()
                    ? lightModeText
                    : darkModeText,
                icon: PreferencesStorage.getIsThemeDark()
                    ? Icons.light_mode
                    : Icons.dark_mode,
                onClicked: () {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(!PreferencesStorage.getIsThemeDark());
                  setState(() {});
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: 'Settings',
                icon: Icons.settings,
                onClicked: widget.onSettingsCallback,
              ),
              _divide(topPadding: dividerSpacing),
              _buildMenuItem(
                topPadding: dividerSpacing,
                text: helpText,
                icon: Icons.help,
                onClicked: () async {
                  Navigator.of(context).pop();
                  var mailUrl = SafeNotesConfig.getMailToForFeedback();
                  try {
                    await launchUrlExternal(Uri.parse(mailUrl));
                  } catch (e) {}
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: sourceCodeText,
                icon: Icons.code,
                onClicked: () async {
                  var sourceCodeUrl = SafeNotesConfig.getSourceCodeUrl();
                  try {
                    await launchUrlExternal(Uri.parse(sourceCodeUrl));
                  } catch (e) {}
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: reportBugText,
                icon: Icons.bug_report,
                onClicked: () async {
                  Navigator.of(context).pop();
                  var mailUrl = SafeNotesConfig.getBugReportUrl();
                  try {
                    await launchUrlExternal(Uri.parse(mailUrl));
                  } catch (e) {}
                },
              ),
              _divide(topPadding: dividerSpacing),
              _buildMenuItem(
                topPadding: dividerSpacing,
                text: logoutText,
                icon: Icons.logout_sharp,
                onClicked: widget.onLogoutCallback,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    required double topPadding,
    Widget? toggle,
    VoidCallback? onClicked,
  }) {
    final double fontSize = 15.0;
    final double leftPaddingMenuItem = 10.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.only(left: leftPaddingMenuItem),
        visualDensity: VisualDensity.compact,
        leading: Icon(icon),
        title: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
        trailing: toggle,
        onTap: onClicked,
      ),
    );
  }

  Widget _drawerHeader({required double topPadding}) {
    final logoPath = SafeNotesConfig.getAppLogoPath();
    final officialAppName = SafeNotesConfig.getAppName();
    final appSlogan = SafeNotesConfig.getAppSlogan();
    final double logoHightWidth = 75.0;
    final double appNameFontSize = 22;
    final double appSloganFontSize = 15;
    final double logoNameGap = 15.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: (EdgeInsets.symmetric(vertical: 5)),
          child: Row(
            children: [
              Center(
                child: Container(
                    width: logoHightWidth,
                    height: logoHightWidth,
                    child: Image.asset(logoPath)),
              ),
              Padding(
                padding: EdgeInsets.only(left: logoNameGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      officialAppName,
                      style: TextStyle(fontSize: appNameFontSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        appSlogan,
                        style: TextStyle(fontSize: appSloganFontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divide({required double topPadding}) {
    final bool isDarkTheme = PreferencesStorage.getIsThemeDark();

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Divider(
        color: isDarkTheme
            ? NordColors.snowStorm.lightest
            : NordColors.polarNight.darker,
      ),
    );
  }
}
