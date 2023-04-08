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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';

Future darkModalBottomSheet(BuildContext context) {
  final _onText = "On".tr();
  final _dimText = "Dim".tr();
  final _offText = "Off".tr();
  final _darkModeText = 'Dark mode'.tr();
  final _lightOutText = "Light out".tr();
  final _darkThemeText = 'Dark theme'.tr();
  final _systemDefaultSettingsText = "Use device settings".tr();

  return showMaterialModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      DarkModeEnum _darkMode =
          DarkModeEnum.values[PreferencesStorage.darkModeEnum];
      DarkThemeEnum _darkTheme =
          DarkThemeEnum.values[PreferencesStorage.darkThemeEnum];

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          final _symetricPadding = MediaQuery.of(context).size.width * 0.04;
          final _topHeadingPadding = MediaQuery.of(context).size.height * 0.03;
          final _leftHeadingPadding = MediaQuery.of(context).size.height * 0.03;
          final _headTextStyle =
              TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
          final _innerTextStyle = TextStyle(fontSize: 15);

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
                padding: EdgeInsets.only(left: _leftHeadingPadding),
                child: Text(_darkModeText, style: _headTextStyle),
              ),
              _divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _symetricPadding),
                child: Column(
                  children: [
                    RadioListTile<DarkModeEnum>(
                      title: Text(_offText, style: _innerTextStyle),
                      value: DarkModeEnum.off,
                      groupValue: _darkMode,
                      onChanged: (value) {
                        setModalStateDarkMode(
                          context: context,
                          setModalState: setModalState,
                          darkMode: _darkMode,
                          value: value,
                          isDarkMode: false,
                        );
                      },
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile<DarkModeEnum>(
                      title: Text(_onText, style: _innerTextStyle),
                      value: DarkModeEnum.on,
                      groupValue: _darkMode,
                      onChanged: (value) {
                        setModalStateDarkMode(
                          context: context,
                          setModalState: setModalState,
                          darkMode: _darkMode,
                          value: value,
                          isDarkMode: true,
                        );
                      },
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile<DarkModeEnum>(
                      title: Text(
                        _systemDefaultSettingsText,
                        style: _innerTextStyle,
                      ),
                      value: DarkModeEnum.device,
                      groupValue: _darkMode,
                      onChanged: (value) {
                        setModalStateDarkMode(
                          context: context,
                          setModalState: setModalState,
                          darkMode: _darkMode,
                          value: value,
                          isDarkMode:
                              MediaQuery.of(context).platformBrightness ==
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
                  top: _topHeadingPadding / 2,
                  left: _leftHeadingPadding,
                ),
                child: Text(_darkThemeText, style: _headTextStyle),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _symetricPadding),
                child: Column(
                  children: [
                    RadioListTile<DarkThemeEnum>(
                      title: Text(_dimText, style: _innerTextStyle),
                      value: DarkThemeEnum.dim,
                      groupValue: _darkTheme,
                      onChanged: (value) {
                        setModalStateDarkTheme(
                          context: context,
                          setModalState: setModalState,
                          darkTheme: _darkTheme,
                          value: value,
                          isDarkDim: true,
                        );
                      },
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile<DarkThemeEnum>(
                      title: Text(_lightOutText, style: _innerTextStyle),
                      value: DarkThemeEnum.lightOut,
                      groupValue: _darkTheme,
                      onChanged: (value) {
                        setModalStateDarkTheme(
                          context: context,
                          setModalState: setModalState,
                          darkTheme: _darkTheme,
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

          // return SingleChildScrollView(
          //   controller: ModalScrollController.of(context),
          //   child: Container(),
          // );
        },
      );
    },
  );
}

//   return showModalBottomSheet(
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//     ),
//     builder: (context) {
//       DarkModeEnum _darkMode =
//           DarkModeEnum.values[PreferencesStorage.darkModeEnum];
//       DarkThemeEnum _darkTheme =
//           DarkThemeEnum.values[PreferencesStorage.darkThemeEnum];

//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setModalState) {
//           final _symetricPadding = MediaQuery.of(context).size.width * 0.04;
//           final _topHeadingPadding = MediaQuery.of(context).size.height * 0.03;
//           final _leftHeadingPadding = MediaQuery.of(context).size.height * 0.03;
//           final _headTextStyle =
//               TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
//           final _innerTextStyle = TextStyle(fontSize: 15);

//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Transform.rotate(
//                 angle: 180 * math.pi / 180,
//                 child: IconButton(
//                   icon: Icon(MdiIcons.colorHelper),
//                   onPressed: null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left: _leftHeadingPadding),
//                 child: Text(_darkModeText, style: _headTextStyle),
//               ),
//               _divider(),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: _symetricPadding),
//                 child: Column(
//                   children: [
//                     RadioListTile<DarkModeEnum>(
//                       title: Text(_offText, style: _innerTextStyle),
//                       value: DarkModeEnum.off,
//                       groupValue: _darkMode,
//                       onChanged: (value) {
//                         setModalStateDarkMode(
//                           context: context,
//                           setModalState: setModalState,
//                           darkMode: _darkMode,
//                           value: value,
//                           isDarkMode: false,
//                         );
//                       },
//                       dense: true,
//                       controlAffinity: ListTileControlAffinity.trailing,
//                     ),
//                     RadioListTile<DarkModeEnum>(
//                       title: Text(_onText, style: _innerTextStyle),
//                       value: DarkModeEnum.on,
//                       groupValue: _darkMode,
//                       onChanged: (value) {
//                         setModalStateDarkMode(
//                           context: context,
//                           setModalState: setModalState,
//                           darkMode: _darkMode,
//                           value: value,
//                           isDarkMode: true,
//                         );
//                       },
//                       dense: true,
//                       controlAffinity: ListTileControlAffinity.trailing,
//                     ),
//                     RadioListTile<DarkModeEnum>(
//                       title: Text(
//                         _systemDefaultSettingsText,
//                         style: _innerTextStyle,
//                       ),
//                       value: DarkModeEnum.device,
//                       groupValue: _darkMode,
//                       onChanged: (value) {
//                         setModalStateDarkMode(
//                           context: context,
//                           setModalState: setModalState,
//                           darkMode: _darkMode,
//                           value: value,
//                           isDarkMode:
//                               MediaQuery.of(context).platformBrightness ==
//                                   Brightness.dark,
//                         );
//                       },
//                       dense: true,
//                       controlAffinity: ListTileControlAffinity.trailing,
//                     ),
//                   ],
//                 ),
//               ),
//               _divider(),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: _topHeadingPadding / 2,
//                   left: _leftHeadingPadding,
//                 ),
//                 child: Text(_darkThemeText, style: _headTextStyle),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: _symetricPadding),
//                 child: Column(
//                   children: [
//                     RadioListTile<DarkThemeEnum>(
//                       title: Text(_dimText, style: _innerTextStyle),
//                       value: DarkThemeEnum.dim,
//                       groupValue: _darkTheme,
//                       onChanged: (value) {
//                         setModalStateDarkTheme(
//                           context: context,
//                           setModalState: setModalState,
//                           darkTheme: _darkTheme,
//                           value: value,
//                           isDarkDim: true,
//                         );
//                       },
//                       dense: true,
//                       controlAffinity: ListTileControlAffinity.trailing,
//                     ),
//                     RadioListTile<DarkThemeEnum>(
//                       title: Text(_lightOutText, style: _innerTextStyle),
//                       value: DarkThemeEnum.lightOut,
//                       groupValue: _darkTheme,
//                       onChanged: (value) {
//                         setModalStateDarkTheme(
//                           context: context,
//                           setModalState: setModalState,
//                           darkTheme: _darkTheme,
//                           value: value,
//                           isDarkDim: false,
//                         );
//                       },
//                       dense: true,
//                       controlAffinity: ListTileControlAffinity.trailing,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

Widget _divider() => Divider(
      color: PreferencesStorage.isThemeDark ? null : Colors.grey.shade400,
    );

void setModalStateDarkTheme({
  required BuildContext context,
  required StateSetter setModalState,
  required DarkThemeEnum darkTheme,
  required var value,
  required bool isDarkDim,
}) {
  final provider = Provider.of<ThemeProvider>(context, listen: false);
  provider.setIsDarkDimTheme(isDarkDim);

  setModalState(() {
    darkTheme = value!;
    PreferencesStorage.setDarkThemeEnum(index: darkTheme.index);
  });
}

void setModalStateDarkMode({
  required BuildContext context,
  required StateSetter setModalState,
  required DarkModeEnum darkMode,
  required var value,
  required bool isDarkMode,
}) {
  final provider = Provider.of<ThemeProvider>(context, listen: false);
  provider.setIsDarkMode(isDarkMode);

  setModalState(() {
    darkMode = value!;
    PreferencesStorage.setDarkModeEnum(index: darkMode.index);
  });
}

enum DarkModeEnum { off, on, device }

enum DarkThemeEnum { dim, lightOut }
