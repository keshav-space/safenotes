// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/utils/url_launcher.dart';
import 'package:safenotes/widgets/dark_mode.dart';

class HomeDrawer extends StatefulWidget {
  final VoidCallback onImportCallback;
  final VoidCallback onChangePassCallback;
  final VoidCallback onLogoutCallback;
  final VoidCallback onSettingsCallback;
  final VoidCallback onBiometricsCallback;

  HomeDrawer({
    Key? key,
    required this.onImportCallback,
    required this.onChangePassCallback,
    required this.onLogoutCallback,
    required this.onSettingsCallback,
    required this.onBiometricsCallback,
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final drawerPaddingHorizontal = 15.0;
    final double itemSpacing = 0.0;
    final double dividerSpacing = 10.0;
    final double drawerRadius = 15.0;

    final String importDataText = 'Import Backup'.tr();
    final String changePassText = 'Change Passphrase'.tr();
    final String darkModeText = 'Dark Mode'.tr();
    final String lightModeText = 'Light Mode'.tr();
    final String settings = 'Settings'.tr();
    final String helpText = 'Help and Feedback'.tr();
    final String faqsText = 'FAQs'.tr();
    final String rateText = 'Rate App'.tr();
    final String logoutText = 'LogOut'.tr();
    final String biometrics = 'Biometric'.tr();

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
              _divide(topPadding: 25),
              _buildMenuItem(
                topPadding: 20,
                text: importDataText,
                icon: MdiIcons.fileDownloadOutline,
                onClicked: widget.onImportCallback,
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: changePassText,
                icon: MdiIcons.keyOutline,
                onClicked: widget.onChangePassCallback,
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: PreferencesStorage.isThemeDark
                    ? lightModeText
                    : darkModeText,
                icon: PreferencesStorage.isThemeDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                onClicked: () {
                  Navigator.of(context).pop();
                  darkModalBottomSheet(context);
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: biometrics,
                icon: Icons.fingerprint,
                onClicked: widget.onBiometricsCallback,
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: settings,
                icon: Icons.settings_outlined,
                onClicked: widget.onSettingsCallback,
              ),
              _divide(topPadding: dividerSpacing),
              _buildMenuItem(
                topPadding: dividerSpacing,
                text: rateText,
                icon: Icons.rate_review_outlined,
                onClicked: () async {
                  Navigator.of(context).pop();
                  String playstoreUrl = SafeNotesConfig.playStoreUrl;
                  try {
                    await launchUrlExternal(Uri.parse(playstoreUrl));
                  } catch (e) {}
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: faqsText,
                icon: MdiIcons.frequentlyAskedQuestions,
                onClicked: () async {
                  Navigator.of(context).pop();
                  String faqsUrl = SafeNotesConfig.FAQsUrl;
                  try {
                    await launchUrlExternal(Uri.parse(faqsUrl));
                  } catch (e) {}
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: helpText,
                icon: Icons.help_outline,
                onClicked: () async {
                  Navigator.of(context).pop();
                  var mailUrl = SafeNotesConfig.mailToForFeedback;
                  try {
                    await launchUrlExternal(Uri.parse(mailUrl));
                  } catch (e) {}
                },
              ),
              _divide(topPadding: dividerSpacing),
              _buildMenuItem(
                topPadding: dividerSpacing,
                text: logoutText,
                icon: Icons.logout,
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
    final logoPath = SafeNotesConfig.appLogoPath;
    final officialAppName = SafeNotesConfig.appName;
    final appSlogan = SafeNotesConfig.appSlogan;
    final double logoHightWidth = 75.0;
    final double appNameFontSize = 20;
    final double appSloganFontSize = 12;
    final double logoNameGap = 10.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: (EdgeInsets.symmetric(vertical: 5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: logoHightWidth,
                  height: logoHightWidth,
                  child: Image.asset(logoPath),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: logoNameGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      officialAppName.tr(),
                      style: TextStyle(fontSize: appNameFontSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        appSlogan.tr(),
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
    final bool isDarkTheme = PreferencesStorage.isThemeDark;

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
