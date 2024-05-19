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
import 'package:provider/provider.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/utils/ios_style_list_tiles.dart';

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
    final dimText = "Dim".tr();
    final darkModeText = 'Dark mode'.tr();
    final lightOutText = "Light out".tr();
    final themeText = 'Theme'.tr();
    final systemDefaultSettingsText = "Use device settings".tr();
    final systemDefaultSettingsSubtitleText =
        "Use device's light or dark mode setting for the app.".tr();

    DarkThemeEnum darkTheme =
        DarkThemeEnum.values[PreferencesStorage.darkThemeEnum];

    bool isThemeActive = Theme.of(context).brightness == Brightness.dark;
    bool isPlatformDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    bool darkModeSwitchValue =
        (PreferencesStorage.isSystemDarkLightSwitchEnabled)
            ? isPlatformDark
            : PreferencesStorage.isLocalDarkSwitchEnabled;

    final symmetricPadding = MediaQuery.of(context).size.width * 0.04;
    final topHeadingPadding = MediaQuery.of(context).size.height * 0.03;
    const headTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    final innerTextStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16);

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -15,
          child: Container(
            width: 40,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: symmetricPadding,
                  right: symmetricPadding,
                  top: symmetricPadding),
              child: Column(
                children: [
                  Text(
                    darkModeText,
                    style: headTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  CupertinoSwitchListTile(
                    title: Text(
                      darkModeText,
                      style: innerTextStyle,
                    ),
                    value: darkModeSwitchValue,
                    onChanged: (bool value) async {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.setIsDarkMode(value);

                      await PreferencesStorage.setLocalDarkSwitchEnabled(value);
                      await PreferencesStorage.setSystemDarkLightSwitchEnabled(
                          false);

                      setState(() {});
                    },
                  ),
                  CupertinoSwitchListTile(
                    title: Text(
                      systemDefaultSettingsText,
                      style: innerTextStyle,
                    ),
                    subtitle: Text(
                      systemDefaultSettingsSubtitleText,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    value: PreferencesStorage.isSystemDarkLightSwitchEnabled,
                    onChanged: (bool value) async {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.setIsDarkMode(isPlatformDark);

                      await PreferencesStorage.setLocalDarkSwitchEnabled(
                          isPlatformDark);
                      await PreferencesStorage.setSystemDarkLightSwitchEnabled(
                          value);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            _divider(),
            Padding(
              padding: EdgeInsets.only(
                top: topHeadingPadding / 4,
              ),
              child: Text(
                themeText,
                style: headTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: symmetricPadding,
                right: symmetricPadding,
                bottom: symmetricPadding + 30,
              ),
              child: Column(
                children: [
                  CupertinoCheckListTile(
                    title: Text(
                      dimText,
                      style: innerTextStyle,
                    ),
                    value: darkTheme == DarkThemeEnum.dim,
                    onChanged: !isThemeActive
                        ? null
                        : (bool? value) {
                            setModalStateDarkTheme(
                              context: context,
                              setState: setState,
                              darkTheme: darkTheme,
                              value: (value == true)
                                  ? DarkThemeEnum.dim
                                  : DarkThemeEnum.lightOut,
                              isDarkDim: true,
                            );
                          },
                  ),
                  CupertinoCheckListTile(
                    title: Text(
                      lightOutText,
                      style: innerTextStyle,
                    ),
                    value: darkTheme == DarkThemeEnum.lightOut,
                    onChanged: !isThemeActive
                        ? null
                        : (bool? value) {
                            setModalStateDarkTheme(
                              context: context,
                              setState: setState,
                              darkTheme: darkTheme,
                              value: (value == true)
                                  ? DarkThemeEnum.lightOut
                                  : DarkThemeEnum.dim,
                              isDarkDim: false,
                            );
                          },
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(
            //     symmetricPadding + 20,
            //     0,
            //     symmetricPadding + 15,
            //     symmetricPadding + 30,
            //   ),
            //   child: Transform.scale(
            //     scale: 1.2,
            //     child: Column(
            //       children: [
            //         CheckboxListTile(
            //           title: Text(
            //             dimText,
            //             style: TextStyle(fontSize: 13),
            //           ),
            //           value: darkTheme == DarkThemeEnum.dim,
            //           checkboxShape: CircleBorder(),
            //           visualDensity: VisualDensity.compact,
            //           onChanged: (bool? value) {
            //             setModalStateDarkTheme(
            //               context: context,
            //               setState: setState,
            //               darkTheme: darkTheme,
            //               value: (value == true)
            //                   ? DarkThemeEnum.dim
            //                   : DarkThemeEnum.lightOut,
            //               isDarkDim: true,
            //             );
            //           },
            //         ),
            //         CheckboxListTile(
            //           title: Text(
            //             lightOutText,
            //             style: TextStyle(fontSize: 13),
            //           ),
            //           value: darkTheme == DarkThemeEnum.lightOut,
            //           checkboxShape: CircleBorder(),
            //           visualDensity: VisualDensity.adaptivePlatformDensity,
            //           onChanged: (bool? value) {
            //             setModalStateDarkTheme(
            //               context: context,
            //               setState: setState,
            //               darkTheme: darkTheme,
            //               value: (value == true)
            //                   ? DarkThemeEnum.lightOut
            //                   : DarkThemeEnum.dim,
            //               isDarkDim: false,
            //             );
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        )
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

enum DarkThemeEnum { dim, lightOut }
