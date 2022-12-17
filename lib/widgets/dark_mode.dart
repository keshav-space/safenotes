// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  final _darkThemeText = 'Dark Theme'.tr();
  final _systemDefaultSettingsText = "Use device settings".tr();

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      DarkMode _darkMode = DarkMode.values[PreferencesStorage.darkModeEnum];
      DarkTheme _darkTheme = DarkTheme.values[PreferencesStorage.darkThemeEnum];

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          final _symetricPadding = MediaQuery.of(context).size.width * 0.04;
          final _topHeadingPadding = MediaQuery.of(context).size.height * 0.03;
          final _leftHeadingPadding = MediaQuery.of(context).size.height * 0.03;
          final _innerTextStyle = TextStyle(fontSize: 15);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(MdiIcons.colorHelper),
              Padding(
                padding: EdgeInsets.only(
                  top: _topHeadingPadding,
                  left: _leftHeadingPadding,
                ),
                child: Text(
                  _darkModeText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              //Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _symetricPadding),
                child: Column(
                  children: [
                    RadioListTile<DarkMode>(
                      title: Text(_offText, style: _innerTextStyle),
                      value: DarkMode.off,
                      groupValue: _darkMode,
                      onChanged: (value) {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.setIsDarkMode(false);

                        setModalState(() {
                          _darkMode = value!;
                          PreferencesStorage.setDarkModeEnum(
                              index: _darkMode.index);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile<DarkMode>(
                      title: Text(_onText, style: _innerTextStyle),
                      value: DarkMode.on,
                      groupValue: _darkMode,
                      onChanged: (value) {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.setIsDarkMode(true);

                        setModalState(() {
                          _darkMode = value!;
                          PreferencesStorage.setDarkModeEnum(
                              index: _darkMode.index);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile<DarkMode>(
                      title: Text(
                        _systemDefaultSettingsText,
                        style: _innerTextStyle,
                      ),
                      value: DarkMode.device,
                      groupValue: _darkMode,
                      onChanged: (value) {
                        var _brightness =
                            MediaQuery.of(context).platformBrightness;
                        bool _isDarkMode = _brightness == Brightness.dark;

                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.setIsDarkMode(_isDarkMode);

                        setModalState(() {
                          _darkMode = value!;
                          PreferencesStorage.setDarkModeEnum(
                              index: _darkMode.index);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  top: _topHeadingPadding / 2,
                  left: _leftHeadingPadding,
                ),
                child: Text(
                  _darkThemeText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _symetricPadding),
                child: Column(
                  children: [
                    RadioListTile<DarkTheme>(
                      title: Text(
                        _dimText,
                        style: _innerTextStyle,
                      ),
                      value: DarkTheme.dim,
                      groupValue: _darkTheme,
                      onChanged: (value) {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.setIsDarkDimTheme(true);

                        setModalState(() {
                          _darkTheme = value!;
                          PreferencesStorage.setDarkThemeEnum(
                              index: _darkTheme.index);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile<DarkTheme>(
                      title: Text(
                        _lightOutText,
                        style: _innerTextStyle,
                      ),
                      value: DarkTheme.lightOut,
                      groupValue: _darkTheme,
                      onChanged: (value) {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.setIsDarkDimTheme(false);

                        setModalState(() {
                          _darkTheme = value!;
                          PreferencesStorage.setDarkThemeEnum(
                              index: _darkTheme.index);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

enum DarkMode { off, on, device }

enum DarkTheme { dim, lightOut }
