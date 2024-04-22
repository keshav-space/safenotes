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
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';

void showThemeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return const ThemeBottomSheet();
    },
  );
}

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  ThemeBottomSheetState createState() => ThemeBottomSheetState();
}

class ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onText = "On".tr();
    final dimText = "Dim".tr();
    final offText = "Off".tr();
    final darkModeText = 'Dark mode'.tr();
    final lightOutText = "Light out".tr();
    final darkThemeText = 'Dark theme'.tr();
    final systemDefaultSettingsText = "Use device settings".tr();

    DarkModeEnum darkMode =
        DarkModeEnum.values[PreferencesStorage.darkModeEnum];
    DarkThemeEnum darkTheme =
        DarkThemeEnum.values[PreferencesStorage.darkThemeEnum];

    final symmetricPadding = MediaQuery.of(context).size.width * 0.04;
    final topHeadingPadding = MediaQuery.of(context).size.height * 0.03;
    final leftHeadingPadding = MediaQuery.of(context).size.height * 0.03;
    const headTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    const innerTextStyle = TextStyle(fontSize: 15);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Transform.rotate(
          angle: 180 * math.pi / 180,
          child: IconButton(
            icon: Icon(MdiIcons.colorHelper),
            onPressed: null,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftHeadingPadding),
          child: Text(darkModeText, style: headTextStyle),
        ),
        _divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: symmetricPadding),
          child: Column(
            children: [
              RadioListTile<DarkModeEnum>(
                title: Text(offText, style: innerTextStyle),
                value: DarkModeEnum.off,
                groupValue: darkMode,
                onChanged: (value) {
                  setModalStateDarkMode(
                    context: context,
                    setState: setState,
                    darkMode: darkMode,
                    value: value,
                    isDarkMode: false,
                  );
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<DarkModeEnum>(
                title: Text(onText, style: innerTextStyle),
                value: DarkModeEnum.on,
                groupValue: darkMode,
                onChanged: (value) {
                  setModalStateDarkMode(
                    context: context,
                    setState: setState,
                    darkMode: darkMode,
                    value: value,
                    isDarkMode: true,
                  );
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<DarkModeEnum>(
                title: Text(
                  systemDefaultSettingsText,
                  style: innerTextStyle,
                ),
                value: DarkModeEnum.device,
                groupValue: darkMode,
                onChanged: (value) {
                  setModalStateDarkMode(
                    context: context,
                    setState: setState,
                    darkMode: darkMode,
                    value: value,
                    isDarkMode: MediaQuery.of(context).platformBrightness ==
                        Brightness.dark,
                  );
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ],
          ),
        ),
        _divider(),
        Padding(
          padding: EdgeInsets.only(
            top: topHeadingPadding / 2,
            left: leftHeadingPadding,
          ),
          child: Text(darkThemeText, style: headTextStyle),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: symmetricPadding),
          child: Column(
            children: [
              RadioListTile<DarkThemeEnum>(
                title: Text(dimText, style: innerTextStyle),
                value: DarkThemeEnum.dim,
                groupValue: darkTheme,
                onChanged: (value) {
                  setModalStateDarkTheme(
                    context: context,
                    setState: setState,
                    darkTheme: darkTheme,
                    value: value,
                    isDarkDim: true,
                  );
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<DarkThemeEnum>(
                title: Text(lightOutText, style: innerTextStyle),
                value: DarkThemeEnum.lightOut,
                groupValue: darkTheme,
                onChanged: (value) {
                  setModalStateDarkTheme(
                    context: context,
                    setState: setState,
                    darkTheme: darkTheme,
                    value: value,
                    isDarkDim: false,
                  );
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _divider() => Divider(
      color: PreferencesStorage.isThemeDark
          ? Colors.grey.shade600
          : Colors.grey.shade500,
    );

void setModalStateDarkTheme({
  required BuildContext context,
  required StateSetter setState,
  required DarkThemeEnum darkTheme,
  required var value,
  required bool isDarkDim,
}) {
  final provider = Provider.of<ThemeProvider>(context, listen: false);
  provider.setIsDarkDimTheme(isDarkDim);

  setState(() {
    darkTheme = value!;
    PreferencesStorage.setDarkThemeEnum(index: darkTheme.index);
  });
}

void setModalStateDarkMode({
  required BuildContext context,
  required StateSetter setState,
  required DarkModeEnum darkMode,
  required var value,
  required bool isDarkMode,
}) {
  final provider = Provider.of<ThemeProvider>(context, listen: false);
  provider.setIsDarkMode(isDarkMode);

  setState(() {
    darkMode = value!;
    PreferencesStorage.setDarkModeEnum(index: darkMode.index);
  });
}

enum DarkModeEnum { off, on, device }

enum DarkThemeEnum { dim, lightOut }
